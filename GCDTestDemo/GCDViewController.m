//
//  GCDViewController.m
//  GCDTestDemo
//
//  Created by BillBo on 2017/8/24.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "GCDViewController.h"

#import "BImageData.h"

@interface GCDViewController ()

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSMutableArray *showImagesArray;

@property (nonatomic, strong) NSMutableArray *threads;


@end

@implementation GCDViewController

- (NSMutableArray *)showImagesArray{
    
    if (!_showImagesArray) {
        self.showImagesArray = [NSMutableArray array];
        
    }
    return _showImagesArray;
}

- (NSMutableArray *)imagesArray{
    
    if (!_imagesArray) {
        
        self.imagesArray = [NSMutableArray array];
        
    }
    
    return _imagesArray;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    for (NSUInteger j = 0; j < 5; j++) {
        
        for (NSUInteger i = 1; i < 10; i ++) {
            
            NSString *urlString = [NSString stringWithFormat:@"http://images.apple.com/v/apple-watch-series-1/e/images/gallery/connected_gallery_%ld_fallback_large_2x.png",i];
            
            [self.imagesArray addObject:urlString];
        }
        
    }
    
    [self layoutUI];
    


}


- (void)layoutUI {
    
    CGFloat space = 5;
    
    CGFloat image_Width = (self.view.frame.size.width - 4 * space)/3;
    
    CGFloat image_Height = image_Width;
    
    NSUInteger section =  self.imagesArray.count/3;
    
    UIScrollView *scv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
    
    scv.contentSize = CGSizeMake(scv.bounds.size.width,(image_Height + space) * section + space);
    
    [self.view addSubview:scv];
    
    for (NSUInteger i = 0 ; i < section; i ++) {
        
        for (NSUInteger j = 0; j < 3; j ++) {
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(space + j * (image_Width + space),space + i * (image_Height + space), image_Width, image_Height)];
            
            imageV.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            imageV.layer.borderWidth = 0.5;
            
            imageV.contentMode = UIViewContentModeScaleAspectFit;
            
            [scv addSubview:imageV];
            
            [self.showImagesArray addObject:imageV];
            
        }
        
    }
    
    [self addButton];
    
}

- (void)addButton {
    
    CGFloat button_Hight = 40;
    
    CGFloat button_Width = (self.view.frame.size.width - 10)/2;
    
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    loadBtn.frame = CGRectMake(0, self.view.frame.size.height - button_Hight, button_Width, button_Hight);
    
    [loadBtn addTarget:self action:@selector(loadImageWithMultiThread:) forControlEvents:UIControlEventTouchUpInside];
    
    [loadBtn setTitle:@"串行dispatch_sync加载" forState:UIControlStateNormal];
    
    loadBtn.backgroundColor = [UIColor cyanColor];
    
    [loadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [loadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:loadBtn];
    
    
    UIButton *cancelLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelLoadBtn.frame = CGRectMake(self.view.frame.size.width - button_Width, self.view.frame.size.height - button_Hight, button_Width, button_Hight);
    
    [cancelLoadBtn addTarget:self action:@selector(dispatch_asyncLoad:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelLoadBtn setTitle:@"并行dispatch_async加载" forState:UIControlStateNormal];
    
    cancelLoadBtn.backgroundColor = [UIColor cyanColor];
    
    [cancelLoadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [cancelLoadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:cancelLoadBtn];

    
}
#pragma mark - 串行加载

- (void)loadImageWithMultiThread:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    
    [self clearImages];
    NSUInteger imageCount = self.imagesArray.count;
    
    //串行队列
    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
  
    //创建多个线程用于填充图片
    for (NSUInteger i=0; i< imageCount; i++) {
        //异步执行队列任务
        dispatch_async(serialQueue, ^{
           
            [self loadImage:i];
        
        });
        
    }
    
    sender.userInteractionEnabled = YES;
    
}

#pragma mark - 并行加载

- (void)dispatch_asyncLoad:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    [self clearImages];
    
    NSUInteger imageCount = self.imagesArray.count;
   
    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建多个线程用于填充图片
    for (NSUInteger i=0; i<imageCount; ++i) {
    
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
        
            [self loadImage:i];
        
        });
    
    }

    sender.userInteractionEnabled = YES;

}


#pragma mark - 请求数据

- (NSData *)requestImageData:(NSUInteger)index {
    
    @autoreleasepool {
        
        NSURL *url = [NSURL URLWithString:self.imagesArray[index]];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        return data;
        
    }
    
}


#pragma mark - 刷新UI

- (void)updateImage:(BImageData *)data {
   
    UIImageView *imageView = self.showImagesArray[data.index.integerValue];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
       
        imageView.image = [UIImage imageWithData:data.data];
        
    });
    
}

- (void)loadImage:(NSUInteger)index {
    
    NSData *data = [self requestImageData:index];
    
    BImageData *imageData = [[BImageData alloc] init];
    
    imageData.data = data;
    
    imageData.index = [NSNumber numberWithInteger:index];
    
    [self updateImage:imageData];
    
}


#pragma mark - 清空图片

- (void)clearImages {
    
    for (UIImageView *imageV in self.showImagesArray) {
        
        imageV.image = nil;
        
    }
    
}


@end
