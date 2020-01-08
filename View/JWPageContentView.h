//
//  JWPageContentView.h
//  JWPageTitleContainerController
//
//  Created by 刘君威 on 2019/12/31.
//  Copyright © 2019 刘君威. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JWPageContentView;
@protocol JWPageContentViewDelegate <NSObject>

@required

///  内容滑动回调
/// @param pageContentView self
/// @param progress 进度
/// @param sourceIndex 原位置
/// @param targetIndex 目标位置
- (void)pageContentView:(JWPageContentView *)pageContentView scrollWithProgress:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex;

@end

@interface JWPageContentView : UIView

@property (nonatomic, weak) id <JWPageContentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame childViewControllers:(NSArray *)childViewControllers;

/// 滑动到指定的indexPath
- (void)scrollToIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
