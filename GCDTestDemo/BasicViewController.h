//
//  BasicViewController.h
//  GCDTestDemo
//
//  Created by BillBo on 2017/8/24.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ThreadType) {
    
    NSThread_ThreadType = 0, //开辟线程加载
    
    MoreNSThread_ThreadType, //多线程
    
    NSOperation_ThreadType, //Operation多线程加载,线程依赖
    
    GCD_ThreadType, //GCD 串行 并行加载
    
    NSLock_ThreadType, //NSLock线程锁
    
    Synchronized_TyreadType, //@synchronized 代码块
    
    GCDSemaphore_ThreadType,//GCD信号量控制线程锁
   
    NSCondition_ThreadType, //NSCondition控制线程通信
    
};

@interface BasicViewController : UIViewController

- (instancetype)initWithThreadType:(ThreadType)type title:(NSString *)title;

@end
