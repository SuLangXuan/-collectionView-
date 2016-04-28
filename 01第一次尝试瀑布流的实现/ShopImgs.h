//
//  ShopImgs.h
//  01第一次尝试瀑布流的实现
//
//  Created by 朗轩 苏 on 16/4/25.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ShopImgs : NSObject
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)shopImgsWithDic:(NSDictionary *)dic;

@end
