//
//  ShopImgs.m
//  01第一次尝试瀑布流的实现
//
//  Created by 朗轩 苏 on 16/4/25.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "ShopImgs.h"

@implementation ShopImgs

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)shopImgsWithDic:(NSDictionary *)dic
{
    return [[self alloc]initWithDic:dic];
}



@end
