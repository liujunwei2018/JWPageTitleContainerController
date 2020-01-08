//
//  JWPageTitleView.h
//  JWPageTitleContainerController
//
//  Created by 刘君威 on 2019/12/31.
//  Copyright © 2019 刘君威. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWPageTitleHeader.h"
NS_ASSUME_NONNULL_BEGIN



@class JWPageTitleView;
@protocol JWPageTitleViewDelegate <NSObject>

- (void)pageTitleView:(JWPageTitleView *)pageTitleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - JWPageTitleView

@interface JWPageTitleView : UIView

@property (nonatomic, weak) id <JWPageTitleViewDelegate> delegate;
/**
 *  标题字体
 */
@property (nonatomic, strong) UIFont *textFont;
/**
 *  标题颜色
 */
@property (nonatomic, assign) JWRGBColor textJWColor;
/**
 *  标题选中颜色,  (默认下划线颜色与标题选中颜色一致),
 *  下划线颜色不随该属性的设置而改变
 */
@property (nonatomic, assign) JWRGBColor textSelectJWColor;
/**
 *  下划线颜色, 默认与 "标题选中颜色" 一致
*/
@property (nonatomic, strong) UIColor *bottomLineColor;
/**
 *  下划线高度, 默认  2.0
*/
@property (nonatomic, assign) CGFloat bottomLineHeight;
/**
 *  隐藏下划线
*/
@property (nonatomic, assign) BOOL hidenBottomLine;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

/// 移动下划线
/// @param progress 进度
/// @param sourceIndex 原 cell 的 index
/// @param targetIndex 目标 cell 的 index
- (void)scrollBottomLineWithProgress:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex;

@end

NS_ASSUME_NONNULL_END
