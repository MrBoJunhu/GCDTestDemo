//
//  NSOperationViewController.m
//  GCDTestDemo
//
//  Created by BillBo on 2017/8/24.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "NSOperationViewController.h"

#import "BImageData.h"

@interface NSOperationViewController ()

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSMutableArray *showImagesArray;

@property (nonatomic, strong) NSMutableArray *threads;


@end

@implementation NSOperationViewController


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
    
    CGFloat button_Width = 120;
    
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    loadBtn.frame = CGRectMake(0, self.view.frame.size.height - button_Hight, button_Width, button_Hight);
    
    [loadBtn addTarget:self action:@selector(loadImageWithMultiThread:) forControlEvents:UIControlEventTouchUpInside];
    
    [loadBtn setTitle:@"加载图片" forState:UIControlStateNormal];
    
    loadBtn.backgroundColor = [UIColor cyanColor];
    
    [loadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [loadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:loadBtn];
    
    
    UIButton *loadLastOneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    loadLastOneBtn.frame = CGRectMake(self.view.frame.size.width - button_Width, self.view.frame.size.height - button_Hight, button_Width, button_Hight);
    
    [loadLastOneBtn addTarget:self action:@selector(loadTheLastOneFirst:) forControlEvents:UIControlEventTouchUpInside];
    
    [loadLastOneBtn setTitle:@"优先最后一个" forState:UIControlStateNormal];
    
    loadLastOneBtn.backgroundColor = [UIColor cyanColor];
    
    [loadLastOneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [loadLastOneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:loadLastOneBtn];
    
}

#pragma mark - 显示图片到界面

- (void)updateImage:(BImageData *)imageData {
    
    UIImage *image = [UIImage imageWithData:imageData.data];
    
    UIImageView *imageView = self.showImagesArray[imageData.index.integerValue];
    
    imageView.image = image;
    
}

#pragma mark - 请求图片数据
- (NSData *)requestData:(NSUInteger)index {
    
    @autoreleasepool {
        
        if (index == 2) {
            
            //设置线程休眠
//          [NSThread sleepForTimeInterval:3];
            
        }
        NSURL *url = [NSURL URLWithString:self.imagesArray[index]];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        return data;
   
    }

}

#pragma mark - 加载图片

- (void)loadImage:(NSNumber *)index {
    
    NSData *data = [self requestData:index.integerValue];
    
    BImageData *imageData = [[BImageData alloc] init];
    
    imageData.data = data;
    
    imageData.index = index;
    
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
    
}

#pragma mark - 多线程下载图片

- (void)loadImageWithMultiThread:(UIButton *)sender {
  
    sender.userInteractionEnabled = NO;
   
    [self clearImages];
    
    NSUInteger operationCount = self.imagesArray.count;
    
    //创建线程队列
    NSOperationQueue *operationQ = [[NSOperationQueue alloc] init];
    //最大的线程并发量
    operationQ.maxConcurrentOperationCount = 5;
    
    for (NSUInteger i = 0; i < operationCount; i++) {
        
        //方法1：创建操作块添加到队列
        //        //创建多线程操作
        //        NSBlockOperation *blockOperation=[NSBlockOperation blockOperationWithBlock:^{
        //            [self loadImage:[NSNumber numberWithInt:i]];
        //        }];
        //        //创建操作队列
        //
        //        [operationQ addOperation:blockOperation];
        
        [operationQ addOperationWithBlock:^{
           
            [self loadImage:[NSNumber numberWithInteger:i]];
            
        }];
        
    }
    
    sender.userInteractionEnabled = YES;
}

- (void)loadTheLastOneFirst:(UIButton *)sender {
   
    sender.userInteractionEnabled = NO;
    
    [self clearImages];
   
    NSUInteger operationCount = self.imagesArray.count;
   
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *lastOperation = [NSBlockOperation blockOperationWithBlock:^{
       
        [self loadImage:[NSNumber numberWithInteger:operationCount - 1]];
        
    }];
    
    for (NSUInteger i = 0; i < operationCount-1; i++) {
        
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
           
            
            [self loadImage:[NSNumber numberWithInteger:i]];
            
        }];
        
        //设置依赖操作
        [blockOperation addDependency:lastOperation];
        
        [q addOperation:blockOperation];
    }
    
    //将依赖加入队列
    [q addOperation:lastOperation];
    
    sender.userInteractionEnabled = YES;
    
}

#pragma mark - 清空图片

- (void)clearImages {
    
    for (UIImageView *imageV in self.showImagesArray) {
        
        imageV.image = nil;
        
    }

}


@end
