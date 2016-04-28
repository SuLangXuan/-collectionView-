//
//  imgCell.m
//  01第一次尝试瀑布流的实现
//
//  Created by 朗轩 苏 on 16/4/25.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "imgCell.h"
#import "ShopImgs.h"
@interface imgCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation imgCell

- (void)configureWithImgs:(ShopImgs *)img
{
    self.priceLable.text = img.price;
    self.imgView.image = [UIImage imageNamed:img.icon];
    self.priceLable.textColor = [UIColor redColor];
    
    [self.contentView bringSubviewToFront:self.priceLable];
}

@end
