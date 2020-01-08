//
//  JWTitleCollectionViewCell.m
//  PageTitleContainerController
//
//  Created by 刘君威 on 2019/12/31.
//  Copyright © 2019 刘君威. All rights reserved.
//

#import "JWTitleCollectionViewCell.h"

@implementation JWTitleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = self.bounds;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];

    [self addSubview:self.titleLabel];
}

@end
