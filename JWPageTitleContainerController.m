//
//  JWPageTitleContainerController.m
//  JWPageTitleContainerController
//
//  Created by 刘君威 on 2019/12/31.
//  Copyright © 2019 刘君威. All rights reserved.
//

#import "JWPageTitleContainerController.h"
#import "JWPageContentView.h"
#import "JWPageTitleView.h"

// 标题高度
static CGFloat kJWPageTitleContainerLineHeight = 40.0;

@interface JWPageTitleContainerController () <JWPageTitleViewDelegate, JWPageContentViewDelegate>

@property (nonatomic, copy) NSArray *childViewControllerArray;
@property (nonatomic, strong) NSMutableArray *childTitleArrays;
@property (nonatomic, strong) JWPageTitleView *jwTitleView;
@property (nonatomic, strong) JWPageContentView *jwContentView;

@end

@implementation JWPageTitleContainerController

- (instancetype)initWithChildViewControllers:(NSArray <UIViewController *> *)childViewControllers {
    if (self = [super init]) {
        self.childViewControllerArray = childViewControllers;

        for (UIViewController *childVC in childViewControllers) {
            [self.childTitleArrays addObject:childVC.title];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleViewHeight = kJWPageTitleContainerLineHeight;
    [self.view addSubview:self.jwTitleView];
    [self.view addSubview:self.jwContentView];
}

#pragma mark - JWPageTitleViewDelegate

- (void)pageTitleView:(JWPageTitleView *)pageTitleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.jwContentView scrollToIndexPath:indexPath];
}

#pragma mark - JWPageContentViewDelegate

- (void)pageContentView:(JWPageContentView *)pageContentView scrollWithProgress:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex {
    [self.jwTitleView scrollBottomLineWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}

#pragma mark - getter setter

- (JWPageTitleView *)jwTitleView {
    if (!_jwTitleView) {
        CGRect frame = self.view.bounds;
        frame.size.height = self.titleViewHeight;
        _jwTitleView = [[JWPageTitleView alloc] initWithFrame:frame titles:self.childTitleArrays];
        _jwTitleView.delegate = self;
    }
    return _jwTitleView;
}

- (JWPageContentView *)jwContentView {
    if (!_jwContentView) {
        CGRect frame = self.view.bounds;
        frame.size.height = self.view.bounds.size.height - self.titleViewHeight;
        frame.origin.y = self.titleViewHeight;
        _jwContentView = [[JWPageContentView alloc] initWithFrame:frame childViewControllers:self.childViewControllerArray];
        _jwContentView.delegate = self;
    }
    return _jwContentView;
}

- (NSMutableArray *)childTitleArrays {
    if (!_childTitleArrays) {
        _childTitleArrays = [NSMutableArray array];
    }
    return _childTitleArrays;
}

@end
