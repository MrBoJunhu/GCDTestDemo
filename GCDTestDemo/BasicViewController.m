;//
//  BasicViewController.m
//  GCDTestDemo
//
//  Created by BillBo on 2017/8/24.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "BasicViewController.h"

#import "ThreadViewController.h"

#import "ThreadMoreViewController.h"

#import "NSOperationViewController.h"

#import "GCDViewController.h"

@interface BasicViewController ()


@property (nonatomic, assign) ThreadType threadType;

@end

@implementation BasicViewController

- (instancetype)initWithThreadType:(ThreadType)type title:(NSString *)title{
    
    if (self = [super init]) {
        
        self.threadType = type;
        
        self.title = title;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    switch (self.threadType) {
        case 0:
        {
            ThreadViewController *threadVC = [[ThreadViewController alloc] init];
            
            [self addChildViewController:threadVC];
            
            [self.view addSubview:threadVC.view];
            
        }
            break;
        case 1:
        {
            ThreadMoreViewController *moreThreadVC = [[ThreadMoreViewController alloc] init];
            
            [self addChildViewController:moreThreadVC];
            
            [self.view addSubview:moreThreadVC.view];
            
        }
            break;
        case 2:
        {
            NSOperationViewController *operationVC = [[NSOperationViewController alloc] init];
            
            [self addChildViewController:operationVC];
            
            [self.view addSubview:operationVC.view];
            
        }
            break;
        case 3:
        {
            GCDViewController *gcdVC = [[GCDViewController alloc] init];
            
            [self addChildViewController:gcdVC];
            
            [self.view addSubview:gcdVC.view];
            
        }
            break;
        default:
            break;
    }
    
}

- (void)layoutUI{
    
    
}


- (void)didReceiveMemoryWarning {
  
    [super didReceiveMemoryWarning];

}

@end
