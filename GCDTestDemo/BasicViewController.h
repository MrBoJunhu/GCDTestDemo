//
//  BasicViewController.h
//  GCDTestDemo
//
//  Created by BillBo on 2017/8/24.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ThreadType) {
    
    NSThread_ThreadType = 0,
    
    MoreNSThread_ThreadType,
    
    NSOperation_ThreadType,
    
    GCD_ThreadType
    
};

@interface BasicViewController : UIViewController

- (instancetype)initWithThreadType:(ThreadType)type title:(NSString *)title;

@end
