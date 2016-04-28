//
//  WaterLayout.h
//  01第一次尝试瀑布流的实现
//
//  Created by 轩 on 16/4/27.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterLayout;

@protocol waterLayoutDelegate <NSObject>

@required
/**返回图片的宽高比*/
- (CGFloat)ratioWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterLayout : UICollectionViewFlowLayout

/*
 这是自定义布局的类。
 
 1.要在StoryBoard面版中，把layout的class改为该类，即可按照该布局类布局。
 */

/** 定义collectionView中的列数*/
@property (nonatomic,assign) short cols;

/**获得模型*/
@property (nonatomic,strong) NSMutableArray *item;

/**指定代理属性*/
@property (nonatomic,weak) id<waterLayoutDelegate> delegate;
@end
