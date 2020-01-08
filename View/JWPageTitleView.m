//
//  JWPageTitleView.m
//  JWPageTitleContainerController
//
//  Created by 刘君威 on 2019/12/31.
//  Copyright © 2019 刘君威. All rights reserved.
//

#import "JWPageTitleView.h"
#import "JWTitleCollectionViewCell.h"

static NSString *kJWPageTitleViewCellID = @"kJWPageTitleViewCellID";
// 底线高度
static CGFloat const kJWPageTitleViewLineHeight = 2.0;
static CGFloat const kJWPageTitleViewAnimationTime = 0.15;
// 默认颜色
static CGFloat const kSelectRed = 255.0;
static CGFloat const kSelectGreen = 165.0;
static CGFloat const kSelectBlue = 0.0;
static CGFloat const kNormalRed = 0.0;
static CGFloat const kNormalGreen = 0.0;
static CGFloat const kNormalBlue = 0.0;

#define kJWPageTitleViewBackgroundColor [UIColor colorWithRed:220.0f / 255.0 green:220.0 / 255.0 blue:220.0 / 255.0 alpha:1]
#define kJWPageTitleViewWidth self.bounds.size.width
#define kJWPageTitleViewHeight self.bounds.size.height

UIColor * setColorWithJWColor(JWRGBColor jwColor) {
    return [UIColor colorWithRed:jwColor.red / 255.0 green:jwColor.green / 255.0 blue:jwColor.blue / 255.0 alpha:1];
}

@interface JWPageTitleView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
// 下划线
@property (nonatomic, strong) UIView *bottomLine;
// 记录cell长度
@property (nonatomic, assign) CGFloat cellWidth;
// 标题数据源
@property (nonatomic, copy) NSArray *titleArray;
// 上一个选中的标题
@property (nonatomic, strong) NSIndexPath *lastSelectIndexPath;
// 当前选中的标题
@property (nonatomic, strong) NSIndexPath *currentSelectIndexPath;
// 是否是点击标题,(另一种是拖动contentView联动标题)
@property (nonatomic, assign) BOOL isClickTitleItem;

@end

@implementation JWPageTitleView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    if (self = [super initWithFrame:frame]) {
        self.titleArray = titles;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = kJWPageTitleViewBackgroundColor;
    // 默认设置
    self.textFont = [UIFont systemFontOfSize:16];
    self.textJWColor = JWRGBColorMake(kNormalRed, kNormalGreen, kNormalBlue);
    self.textSelectJWColor = JWRGBColorMake(kSelectRed, kSelectGreen, kSelectBlue);
    self.bottomLineColor = setColorWithJWColor(self.textSelectJWColor);
    self.bottomLineHeight = kJWPageTitleViewLineHeight;
    
    [self addSubview:self.collectionView];
    [self addSubview:self.bottomLine];
    
    self.currentSelectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    self.lastSelectIndexPath = nil;
}

#pragma mark - public

- (void)scrollBottomLineWithProgress:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex {
    if (self.isClickTitleItem) {
        self.isClickTitleItem = NO;
        return;
    }
    // 设置颜色
    for (JWTitleCollectionViewCell *cell in self.collectionView.visibleCells) {
        cell.titleLabel.textColor = setColorWithJWColor(self.textJWColor);
    }
    
    self.lastSelectIndexPath = [NSIndexPath indexPathForItem:sourceIndex inSection:0];
    self.currentSelectIndexPath = [NSIndexPath indexPathForItem:targetIndex inSection:0];
    JWTitleCollectionViewCell *lastSelectCell = (JWTitleCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.lastSelectIndexPath];
    JWTitleCollectionViewCell *currentSelectCell = (JWTitleCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.currentSelectIndexPath];
    
    // 下划线X偏移
    CGFloat moveTotalX = currentSelectCell.frame.origin.x - lastSelectCell.frame.origin.x;
    CGFloat moveX = moveTotalX * progress;
    CGRect frame = self.bottomLine.frame;
    frame.origin.x = lastSelectCell.frame.origin.x + moveX;
    self.bottomLine.frame = frame;
    
    // 渐变颜色
    CGFloat kOffsetRed = self.textSelectJWColor.red * progress;
    CGFloat kOffsetGreen = self.textSelectJWColor.green * progress;
    CGFloat kOffsetBlue = self.textSelectJWColor.blue * progress;
    lastSelectCell.titleLabel.textColor = setColorWithJWColor(JWRGBColorMake(self.textSelectJWColor.red - kOffsetRed, self.textSelectJWColor.green - kOffsetGreen, self.textSelectJWColor.blue - kOffsetBlue));
    currentSelectCell.titleLabel.textColor = setColorWithJWColor(JWRGBColorMake(self.textJWColor.red + kOffsetRed, self.textJWColor.green + kOffsetGreen, self.textJWColor.blue + kOffsetBlue));
}

#pragma mark - delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentSelectIndexPath == self.lastSelectIndexPath && self.currentSelectIndexPath == indexPath) {
        return;
    }
    self.isClickTitleItem = YES;
    
    // 先设置为默认颜色
    for (JWTitleCollectionViewCell *cell in self.collectionView.visibleCells) {
        cell.titleLabel.textColor = setColorWithJWColor(self.textJWColor);
    }
    
    //记录上一个选中的item
    self.lastSelectIndexPath = self.currentSelectIndexPath;
    //更新当前选中的item
    self.currentSelectIndexPath = indexPath;

    //移动下划线偏移量计算
    NSInteger lineX = self.cellWidth * indexPath.item;
    CGRect frame = self.bottomLine.frame;
    frame.origin.x = lineX;

    [UIView animateWithDuration:kJWPageTitleViewAnimationTime animations:^{
        self.bottomLine.frame = frame;
    }];
    
    //修改标题颜色
    JWTitleCollectionViewCell *lastSelectCell = (JWTitleCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.lastSelectIndexPath];
    JWTitleCollectionViewCell *currentSelectCell = (JWTitleCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.currentSelectIndexPath];
    lastSelectCell.titleLabel.textColor = setColorWithJWColor(self.textJWColor);
    currentSelectCell.titleLabel.textColor = setColorWithJWColor(self.textSelectJWColor);

    if ([self.delegate respondsToSelector:@selector(pageTitleView:didSelectItemAtIndexPath:)]) {
        [self.delegate pageTitleView:self didSelectItemAtIndexPath:indexPath];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.titleArray) {
        return self.titleArray.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JWTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJWPageTitleViewCellID forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.item];
    cell.titleLabel.textColor = setColorWithJWColor(self.textJWColor);
    cell.titleLabel.font = self.textFont;
    if (indexPath.item == self.currentSelectIndexPath.item) {
        cell.titleLabel.textColor = setColorWithJWColor(self.textSelectJWColor);
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.titleArray && self.titleArray.count > 0) {
        //确定cell大小,初始下横线大小
        self.cellWidth = kJWPageTitleViewWidth / self.titleArray.count;
        self.bottomLine.frame = CGRectMake(0, (kJWPageTitleViewHeight - self.bottomLineHeight), self.cellWidth, self.bottomLineHeight);
        
        return CGSizeMake(self.cellWidth, kJWPageTitleViewHeight - self.bottomLineHeight);
    }
    return CGSizeZero;
}

#pragma mark - getter setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        CGRect frame = self.bounds;
        frame.size.height = (self.bounds.size.height - kJWPageTitleViewLineHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[JWTitleCollectionViewCell class] forCellWithReuseIdentifier:kJWPageTitleViewCellID];
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor orangeColor];
    }
    return _bottomLine;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [self.collectionView reloadData];
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    self.bottomLine.backgroundColor = _bottomLineColor;
}

- (void)setTextJWColor:(JWRGBColor)textJWColor {
    _textJWColor = textJWColor;
    [self.collectionView reloadData];
}

- (void)setTextSelectJWColor:(JWRGBColor)textSelectJWColor {
    _textSelectJWColor = textSelectJWColor;
    [self.collectionView reloadData];
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight {
    _bottomLineHeight = bottomLineHeight;
    CGRect frame = self.bottomLine.frame;
    frame.size.height = _bottomLineHeight;
    frame.origin.y = kJWPageTitleViewHeight - _bottomLineHeight;
    self.bottomLine.frame = frame;
}

- (void)setHidenBottomLine:(BOOL)hidenBottomLine {
    _hidenBottomLine = hidenBottomLine;
    self.bottomLine.hidden = _hidenBottomLine;
}

@end
