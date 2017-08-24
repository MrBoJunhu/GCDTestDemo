//
//  ThreadViewController.m
//  GCDTestDemo
//
//  Created by BillBo on 2017/8/24.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "ThreadViewController.h"

static NSString *image_url = @"http://images.apple.com/v/apple-watch-series-1/e/images/gallery/connected_gallery_1_fallback_large_2x.png";

@interface ThreadViewController ()  {
    
    UIImageView *imageView;
        
}

@end

@implementation ThreadViewController


- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    [self layoutUI];

}

- (void)layoutUI{
    
    [self addImageViewToView:self.view];
    
    [self addButton];
}

- (void)addImageViewToView:(UIView *)view {
    
    imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    
    imageView.backgroundColor = [UIColor lightGrayColor];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [view addSubview:imageView];
    
}

- (void)addButton {
    
    CGFloat button_Hight = 40;
    
    CGFloat button_Width = 120;
    
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    loadBtn.frame = CGRectMake(0, self.view.frame.size.height - button_Hight, button_Width, button_Hight);
    
    [loadBtn addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    
    [loadBtn setTitle:@"加载图片" forState:UIControlStateNormal];
    
    loadBtn.backgroundColor = [UIColor cyanColor];
    
    [loadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [loadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:loadBtn];
    
}

- (void)loadImageWithMultiThread {
    
    //方法1：使用对象方法
    //创建一个线程，第一个参数是请求的操作，第二个参数是操作方法的参数
    
    //    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
    //
    //    //启动一个线程，注意启动一个线程并非就一定立即执行，而是处于就绪状态，当系统调度时才真正执行
    //    [thread start];
    
    //方法2：使用类方法
    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];
    
}


#pragma mark 将图片显示到界面
-(void)updateImage:(NSData *)imageData{
    
    UIImage *image=[UIImage imageWithData:imageData];
    
    imageView.image=image;
    
}

#pragma mark - 加载图片

- (void)loadImage{
    
    NSData *imageData = [self requestData];
    
    /*将数据显示到UI控件,注意只能在主线程中更新UI,
     另外performSelectorOnMainThread方法是NSObject的分类方法，每个NSObject对象都有此方法，
     它调用的selector方法是当前调用控件的方法，例如使用UIImageView调用的时候selector就是UIImageView的方法
     Object：代表调用方法的参数,不过只能传递一个参数(如果有多个参数请使用对象进行封装)
     waitUntilDone:是否线程任务完成执行
     */
    
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
    
}


#pragma mark - 请求图片数据

- (NSData *)requestData {
    
    @autoreleasepool {
        
        NSURL *url = [NSURL URLWithString:image_url];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        return data;
        
    }
    
}


@end
