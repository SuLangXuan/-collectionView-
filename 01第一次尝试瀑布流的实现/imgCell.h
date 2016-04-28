//
//  imgCell.h
//  01第一次尝试瀑布流的实现
//
//  Created by 朗轩 苏 on 16/4/25.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopImgs;


@interface imgCell : UICollectionViewCell


/**配置图片跟价格的方法*/
- (void)configureWithImgs:(ShopImgs *)img;



@end
