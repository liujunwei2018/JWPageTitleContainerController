//
//  JWPageTitleContainerController.h
//  JWPageTitleContainerController
//
//  Created by 刘君威 on 2019/12/31.
//  Copyright © 2019 刘君威. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWPageTitleHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface JWPageTitleContainerController : UIViewController

/// init
/// @param childViewControllers 子控制器数组, 标题会设置为对应的 vc.title
- (instancetype)initWithChildViewControllers:(NSArray <UIViewController *> *)childViewControllers;

@end

NS_ASSUME_NONNULL_END
