//
//  ViewController.m
//  01第一次尝试瀑布流的实现
//
//  Created by 朗轩 苏 on 16/4/25.
//  Copyright © 2016年 itcast. All rights reserved.
/*
 1.创建模型数组，和懒加载。
 2.创建collectionView,创建cell,并实现数据源方法。
 3.返回footerView并实现刷新功能。
 */

#import "ViewController.h"
#import "ShopImgs.h"
#import "imgCell.h"
#import "FooterView.h"
#import "WaterLayout.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,waterLayoutDelegate>

@property (nonatomic,strong) NSMutableArray *imgs;
/**自定义布局的layout*/
@property (weak, nonatomic) IBOutlet WaterLayout *waterLayout;

/**添加一个当前读取文件的索引*/
@property (nonatomic,assign) int currentPlistNum;
/**设置一个属性来判断当前是否正在加载数据。*/
@property (nonatomic,assign,getter=isLoading) BOOL isLoading;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使用系统的layout实现布局。
   
    self.collectionView.backgroundColor = [UIColor greenColor];
    
    self.waterLayout.cols = 3;
    
    //设置代理
    self.waterLayout.delegate = self;
    
}

#pragma mark - waterLayoutDelegate
- (CGFloat)ratioWithIndexPath:(NSIndexPath *)indexPath
{
    ShopImgs *currentItem = self.imgs[indexPath.item];
    return currentItem.height/currentItem.width;
}

#pragma mark - DataSource
//返回每一个组中有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgs.count;
}

//返回的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    imgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    //configure cell
    [cell configureWithImgs:self.imgs[indexPath.item]];
    return cell;
}

//返回头部与底部的view
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    //根据kind的类型黎返回view
    if (kind == UICollectionElementKindSectionFooter)
    {
        FooterView *fv = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"imgFooter" forIndexPath:indexPath];
        
           //我要实现的是，无论用户划多少次，都只加载一次。
            if(self.isLoading == NO)//没有加载
            {
                self.isLoading = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadMoreDate];
                    [self.collectionView reloadData];
                    self.isLoading = NO;
                });
                
            }

        return fv;
    }
    

    
    return nil;
}



#pragma mark - private

/**读取plist文件的方法*/
//返回一个可变数组，存储plist文件中的数据。
- (NSMutableArray *)readPlistFileWithplistNum:(NSInteger)plistNum
{
    //如果超过就不获取。
    if (plistNum >3 || plistNum <1)
    {
        return nil;
    }
    
    //获取文件名
    NSString *plistFileName = [NSString stringWithFormat:@"%ld.plist",plistNum];
    
    //根据文件名获取数据
    NSArray *dicArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistFileName ofType:nil]];
    NSMutableArray *imgs = [NSMutableArray arrayWithCapacity:dicArr.count];
    for (NSDictionary *dic in dicArr)
    {
        [imgs addObject:[ShopImgs shopImgsWithDic:dic]];
    }
    return imgs;
}


/**加载数据的方法*/

- (void)loadMoreDate
{NSLog(@"数据加载了%d次",self.currentPlistNum+1);
    self.currentPlistNum++;//1.->2 2.->3 3
    //进行加载数据的操作。读取plist文件
    NSMutableArray *loadArr = [self readPlistFileWithplistNum:self.currentPlistNum%3+1];
    //把加载到的数据添加到展示cell的数组中。
    [self.imgs addObjectsFromArray:loadArr];
    //实现循环加载文件,循环读取3个plist文件。
//    1.-》2
//    2-》3
//    3-》1  currentplistnum 的变化。
    
    
}











#pragma mark - getter
//lazyload
- (NSMutableArray *)imgs
{
    if (!_imgs)
    {   //默认第一次加载第1个plist文件。
        _imgs = [self readPlistFileWithplistNum:1];
    }
    return _imgs;
}

//为布局类中的模型类懒加载。
- (WaterLayout *)waterLayout
{
    if (_waterLayout.item == nil)
    {
        _waterLayout.item = self.imgs;
    }
    return _waterLayout;
}


@end
