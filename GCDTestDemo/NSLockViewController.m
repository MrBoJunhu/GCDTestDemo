//
//  NSLockViewController.m
//  GCDTestDemo
//
//  Created by BillBo on 2017/8/25.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "NSLockViewController.h"

#import "BImageData.h"

@interface NSLockViewController (){
    NSLock *_lock;
}

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSMutableArray *showImagesArray;


@end

@implementation NSLockViewController


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


/*
 拿图片加载来举例，假设现在有9张图片，但是有15个线程都准备加载这9张图片，约定不能重复加载同一张图片，这样就形成了一个资源抢夺的情况。在下面的程序中将创建9张图片，每次读取照片链接时首先判断当前链接数是否大于1，用完一个则立即移除，最多只有9个
 */
- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    //线程锁初始化
    _lock = [[NSLock alloc] init];
    
    [self resetImages];
    
    [self layoutUI];

}

- (void)resetImages {
    
    for (NSUInteger i = 1; i < 10; i ++) {
        
        NSString *urlString = [NSString stringWithFormat:@"http://images.apple.com/v/apple-watch-series-1/e/images/gallery/connected_gallery_%ld_fallback_large_2x.png",i];
        
        [self.imagesArray addObject:urlString];

    }

}


- (void)layoutUI {
    
    CGFloat space = 5;
    
    CGFloat image_Width = (self.view.frame.size.width - 4 * space)/3;
    
    CGFloat image_Height = image_Width;
    
//    NSUInteger section =  self.imagesArray.count/3;

    NSUInteger section =  4;

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
    
    CGFloat button_Width = (self.view.frame.size.width - 2)/2;
    
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    loadBtn.frame = CGRectMake(0, self.view.frame.size.height - button_Hight, button_Width, button_Hight);
    
    [loadBtn addTarget:self action:@selector(loadImageWithNSLock:) forControlEvents:UIControlEventTouchUpInside];
    
    [loadBtn setTitle:@"NSLock加载" forState:UIControlStateNormal];
    
    loadBtn.backgroundColor = [UIColor cyanColor];
    
    [loadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [loadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:loadBtn];
    
    
    UIButton *cancelLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelLoadBtn.frame = CGRectMake(self.view.frame.size.width - button_Width, self.view.frame.size.height - button_Hight, button_Width, button_Hight);
    
}

#pragma mark - 线程锁并发加载图片

- (void)loadImageWithNSLock:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
  
    [self resetImages];
    
    [self clearImages];
    
    NSUInteger imageCount = self.showImagesArray.count;

    // imageView 数量大于 9
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (NSUInteger i = 0; i < imageCount; i++) {
        
        dispatch_async(globalQueue, ^{
           
            [self loadImage:i];
            
        });
    }
    
    sender.userInteractionEnabled = YES;
    
}

#pragma mark - 请求数据

- (NSData *)requestData:(NSUInteger)index {
    
    @autoreleasepool {
        
        NSString *urlString;
        
        NSData *data;
        //加锁
        [_lock lock];
        
        if (self.imagesArray.count > 0 ) {
       
            //如果还有图片未加载
            urlString = self.imagesArray.lastObject;
            
            [self.imagesArray removeObject:urlString];
        }
        
        //使用完解锁
        [_lock unlock];
        
        if (urlString) {
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            data = [NSData dataWithContentsOfURL:url];

        }

        return data;
        
    }
    
}

- (void)loadImage:(NSUInteger)index {
    
    NSData *data = [self requestData:index];
    
    BImageData *imageData = [[BImageData alloc] init];
    
    imageData.data = data;
    
    imageData.index = [NSNumber numberWithInteger:index];
    
    [self updateImage:imageData];
    
}


#pragma mark - 显示图片

- (void)updateImage:(BImageData *)imageData {
    
    UIImageView *imageV = self.showImagesArray[imageData.index.integerValue];
    
    UIImage *image = [UIImage imageWithData:imageData.data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        imageV.image = image;
        
    });
    
}


#pragma mark - 清空图片

- (void)clearImages {
    
    for (UIImageView *imageV in self.showImagesArray) {
        
        imageV.image = nil;
        
    }
    
}



@end
