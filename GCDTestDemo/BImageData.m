//
//  BImageData.m
//  GCDTestDemo
//
//  Created by BillBo on 2017/8/24.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "BImageData.h"

@implementation BImageData

- (void)setData:(NSData *)data {
    
    _data = [NSData dataWithData:data];
    
}

- (void)setIndex:(NSNumber *)index {
    
    _index = index;
    
}
@end
