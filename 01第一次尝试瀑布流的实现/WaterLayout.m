//
//  WaterLayout.m
//  01第一次尝试瀑布流的实现
//
//  Created by 轩 on 16/4/27.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "WaterLayout.h"
#import "ShopImgs.h"
@interface WaterLayout ()
/**存储每个item属性的数组*/
@property (nonatomic,strong) NSMutableArray *attributes;

/** 用来存储每一列的最大的Y值的数组 */
@property (nonatomic,strong) NSMutableArray *maxYs;
@end


@implementation WaterLayout


#pragma mark - 重写布局的方法
//自定义layout
/**
 1.在屏幕初始化的时候调用。
 2.在屏幕尺寸发生变化的时候调用（转屏）。
 3.重新加载数据时调用。
 说白了，就是item要布局的时候调用，在这里计算item的布局属性。
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.sectionInset = UIEdgeInsetsMake(20, 20, 0, 20);
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.collectionView.contentSize = [self setContentSize];
    
    
    //清空footerView的布局属性.
    [self.attributes removeLastObject];
    
    //清掉原来的Y值。
//    self.maxYs = nil;
    
    
    
    // ******************    0.从数据源中获得有多少个Cell    ****************
    //获取collectionView中有多少组
    //    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    //获取collectionView中第0组有多少个items
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    // ******************    1.计算layoutAttributes    ****************
    
    //有多少个item就要计算全部item的布局属性。
//        for (int i = 0; i < itemCount; i++)//不够好，因为之前算好的frame值，还要重新算一次。
    //        优化，从新进来的item开始算，之前算好的就不用算了。
    for (NSInteger i = self.attributes.count; i < itemCount; i++)
            //出错了。布局重叠
    {
        //1.0获得第0组每个item的索引。
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //1.1创建布局属性对象。
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        //1.2计算布局属性
        //        attribute.frame = CGRectMake(0, 0, 100, 100);//test
        attribute.frame = [self attributeFrameWithIndexPath:indexPath];
        
        //1.3把布局属性存入到存储布局属性的数组。
        [self.attributes addObject:attribute];
        
        //1.4通过系统方法返回已经计算好布局属性的数组。
    }
    
    
    // 2.设置footer的布局属性。
    //  2.1创建footer的布局属性。
    UICollectionViewLayoutAttributes *footerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    //2.2设置frame
    CGFloat x = 0;
    CGFloat y = [self maxYFormaxYs] - self.minimumLineSpacing + self.sectionInset.bottom ;
    CGFloat w = self.collectionView.bounds.size.width;
    CGFloat h = self.footerReferenceSize.height;
    footerAttribute.frame = CGRectMake(x, y, w, h);
    
    //3.把计算好的布局属性存入到存储布局属性的数组。
    [self.attributes addObject:footerAttribute];
}

/**设置当前collectionView的滚动范围是多少。*/
- (CGSize)collectionViewContentSize
{
    return [self setContentSize];
}


/**返回布局属性数组*/
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    //1.4通过系统方法返回已经计算好布局属性的数组。
    return self.attributes;
}

#pragma mark - getter/lazyload
/** （懒加载）为属性数组赋值，因为当前没为attributes赋值，所以默认是nil*/
- (NSMutableArray *)attributes
{
    if (_attributes == nil)
    {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

/** 为maxYs数组赋值，懒加载*/
- (NSMutableArray *)maxYs
{
    if (_maxYs == nil)
    {
        
        //妈蛋！！！！********************************//!Y值一直算不出来，就是因为你。
        _maxYs = [NSMutableArray array];
        //!Y值一直算不出来，就是因为你。***************************
        /*
         因为，只是声明了一个NSmutableArray的变量，默认值是nil,
         
         就如：
         int a;
         现在a是空的，什么都没有，所以要先赋值。
         */
        
        
        //为maxY赋默认值。
        CGFloat maxY = self.sectionInset.top ;
        
        /*
         //关于封装的练习。
         NSNumber *num = [NSNumber numberWithFloat:maxY];
         
         //拆箱的练习
         CGFloat aa = [num floatValue];
         NSLog(@"%f",aa);
         */
        
        //有多少列就添加多少个maxY值来记录
        for (int i = 0 ; i < self.cols; i++)
        {
            //添加maxY,因为oc数组只能存对象，所以要把CGFloat的Y封装成对象，才能存到oc数组中。
            [_maxYs addObject:@(maxY)];
        }
    }
    return _maxYs;
}

#pragma mark - 计算布局属性

/**返回布局属性的frame值。*/
- (CGRect)attributeFrameWithIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = [self itemWidth];
    CGFloat itemHeight = [self itemHeightWithIndexPath:indexPath andItemWith:itemWidth];
    CGFloat itemX = [self itemXWithitemWidth:itemWidth andindexPath:indexPath];
    
    CGFloat itemY = [self itemYWithIndexPath:indexPath andHeight:itemHeight];
    
    CGRect attributeFrame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    //    NSLog(@"%f",itemWidth);
    //    NSLog(@"%f",itemHeight);
    //    NSLog(@"%f",itemX);
    NSLog(@"%f",itemY);
    return attributeFrame;
}


/** 计算每个item的宽度 */
- (CGFloat)itemWidth
{
    //    图片的宽度 = （当前collectionView的宽度 - 当前组的左右内边距 - 每个cell之间的最小间距*（当前列数-1））/列数
    
    return (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing*(self.cols - 1))/self.cols;
}

/**
 *  计算item的高度。
 *
 *  @param indexPath 当前item的索引
 *  @param itemWidth 当前item的宽度
 *
 *  @return item的高度，item在当前collectionView中显示的高度。
 */
- (CGFloat)itemHeightWithIndexPath:(NSIndexPath *)indexPath andItemWith:(CGFloat) itemWidth
{
    // 图片的高度 = （模型数组中图片的真实高度*在collectionView中显示的宽度）/模型数组中图片的真实宽度。
    //获得当前item的模型
//    ShopImgs *currentImg = self.item[indexPath.item];
//    CGFloat itemHeight = (currentImg.height*itemWidth)/currentImg.width;
    CGFloat itemHeight = 0;
    if ([self.delegate respondsToSelector:@selector(ratioWithIndexPath:)])
    {
         itemHeight = [self.delegate ratioWithIndexPath:indexPath] * itemWidth;
    }
    
    return itemHeight;
}


/**计算item在collectionView中的X坐标*/
- (CGFloat)itemXWithitemWidth:(CGFloat)itemWidth andindexPath:(NSIndexPath *)indexPath
{
    //v2.0
    
    short minCol = [self minColInmaxYs];
    
    return self.sectionInset.left + (itemWidth+self.minimumInteritemSpacing) *minCol;
    
//    v1.0
    //    图片的X坐标值 = 当前组的左内边距 + （当前图片在collectionView中显示的宽度+每个cell之间的最小间距）* （当前item的索引%列数）；
//    return self.sectionInset.left + (itemWidth+self.minimumInteritemSpacing) * (indexPath.item%self.cols);
    
    
}

/** 计算item的Y坐标值。 */
- (CGFloat)itemYWithIndexPath:(NSIndexPath *)indexPath andHeight:(CGFloat)itemHeight
{
    /*
     图片的Y坐标值 =
     第一行 ： 当前组的上内边距 ；
     其它行 ： 上一张图片的最大Y值 + 行间距；
     */
    
    
    //获取当前列数，根据列数获取相应的maxY
//    short col = indexPath.item % self.cols;
    short col = [self minColInmaxYs];
    
    //然后根据maxY值设置坐标
    //当前item的Y坐标
    CGFloat itemY = [self.maxYs[col] floatValue];
    //然后修改maxY的值。
    self.maxYs[col] = @(itemY + itemHeight + self.minimumLineSpacing);
    
    return itemY;
    
    /*
     如果Y值没出来：
     1.算法错了。
     2.maxYs数组为空，还未初始化。
     3.参数和公式中的属性值，还未赋值。
     */
}


/**计算最大的Y值*/
- (CGFloat)maxYFormaxYs
{
    CGFloat maxY = [self.maxYs[0] floatValue];
    for (NSNumber *num in self.maxYs)
    {
        if ([num floatValue] > maxY)
        {
            maxY = [num floatValue];
        }
    }
    return maxY;
}


/**获得最短的列号*/
- (short)minColInmaxYs
{
    //定义一个默认最小的列数
    short minCol = 0;
    //然后比较，获得最短的列号。
    for (int i = 0; i < self.cols; i++)
    {
        if ([self.maxYs[i] floatValue] < [self.maxYs[minCol] floatValue])
        {
            minCol = i;
        }
    }
    
    
    return minCol;
}


/** 计算最小的Y值 */
- (CGFloat)minYFormaxYs
{
    CGFloat minY = [self.maxYs[0] floatValue];
    for (NSNumber *num in self.maxYs)
    {
        if ([num floatValue] < minY)
        {
            minY = [num floatValue];
        }
    }
    return minY;
}

#pragma mark - contenSize的计算。
//布局后出现的问题，contenetSize很长，不再自已设置的范围内。底部的加载条也因此消失了。

/**设置contensize的大小。*/
- (CGSize)setContentSize
{
    
    //    //判断列的maxY
    //    CGFloat max = [self.maxYs[0] floatValue];
    //    for (int i = 0; i < self.maxYs.count; i++)
    //    {
    //        if (max < [self.maxYs[i] floatValue])
    //        {
    //            max = [self.maxYs[i] floatValue];
    //        }
    //    }
    CGFloat max = [self maxYFormaxYs];
    
    //需要列中最大的maxY高度
    CGFloat height = max - self.minimumLineSpacing +self.sectionInset.bottom+self.footerReferenceSize.height;
    return   CGSizeMake(self.collectionView.bounds.size.width, height);
}




@end
