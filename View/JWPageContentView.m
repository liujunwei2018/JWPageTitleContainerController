//
//  JWPageContentView.m
//  JWPageTitleContainerController
//
//  Created by 刘君威 on 2019/12/31.
//  Copyright © 2019 刘君威. All rights reserved.
//

#import "JWPageContentView.h"

#define kJWPageContentViewWidth self.bounds.size.width
#define kJWPageContentViewHeight self.bounds.size.height
static NSString * cellID = @"JWPageContentViewCellID";

@interface JWPageContentView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *childViewControllers;
// 初始偏移记录
@property (nonatomic, assign) CGFloat startOffsetX;

@end

@implementation JWPageContentView

- (instancetype)initWithFrame:(CGRect)frame childViewControllers:(NSArray *)childViewControllers {
    if (self = [super initWithFrame:frame]) {
        self.childViewControllers = childViewControllers;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.childViewControllers) {
        return self.childViewControllers.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
  
    UIViewController *childVC = self.childViewControllers[indexPath.item];
    childVC.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVC.view];

    return cell;
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int sourceIndex = 0;  //原位置
    int targetIndex = 0;  //目标位置
    CGFloat progress = 0;
    CGFloat currentOffsetX = scrollView.contentOffset.x;

    //2.判断是左滑还是又滑
    if (currentOffsetX > self.startOffsetX) { // 左滑
        NSLog(@"********** 左滑 **********");
        //1.计算progress   floor()取整
        progress = currentOffsetX / kJWPageContentViewWidth - floor(currentOffsetX / kJWPageContentViewWidth);
        //2.计算sourceIndex 原
        sourceIndex = currentOffsetX / kJWPageContentViewWidth;

        targetIndex = sourceIndex + 1;

        //3.计算targetIndex
        // 当滑到最后一个时
        if (targetIndex == self.childViewControllers.count) {
            progress = 1;
            targetIndex = (int)self.childViewControllers.count -1;
            sourceIndex = targetIndex;
        }
        
        //4.如果完全划过去
        if (currentOffsetX - self.startOffsetX == kJWPageContentViewWidth) {
            progress = 1;
            targetIndex = sourceIndex;
        }
    }else {  //右滑
        NSLog(@"********** 右滑 **********");
        //1.计算progress
        progress = 1 - (currentOffsetX / kJWPageContentViewWidth - floor(currentOffsetX / kJWPageContentViewWidth));
        
        //2.计算targetIndex
        targetIndex = currentOffsetX / kJWPageContentViewWidth;
        
        //3.计算sourceIndex
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childViewControllers.count) {
            targetIndex = (int)self.childViewControllers.count - 1;
            sourceIndex = targetIndex - 1;
        }
        
        //4.如果完全划过去
        if (self.startOffsetX - currentOffsetX == kJWPageContentViewWidth) {
            progress = 1;
            sourceIndex = targetIndex;
        }
    }
    
    NSLog(@"\nstartOffsetX = %f,\ncurrentOffsetX = %f,\nprogress = %f,\nsourceIndex = %d,\ntargetIndex = %d\n",self.startOffsetX, currentOffsetX, progress, sourceIndex, targetIndex);

    if ([self.delegate respondsToSelector:@selector(pageContentView:scrollWithProgress:sourceIndex:targetIndex:)]) {
        [self.delegate pageContentView:self scrollWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
}

// 得到起始位置的偏移量
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startOffsetX = scrollView.contentOffset.x;
}

#pragma mark - public
- (void)scrollToIndexPath:(NSIndexPath *)indexPath {
    CGFloat offsetX = indexPath.item * kJWPageContentViewWidth;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0)];
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

@end
