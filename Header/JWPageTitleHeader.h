//
//  JWPageTitleHeader.h
//  JWPageTitleContainerController
//
//  Created by 刘君威 on 2020/1/8.
//  Copyright © 2020 liujunwei2018. All rights reserved.
//

struct JWRGBColor {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
};
typedef struct JWRGBColor JWRGBColor;

CG_INLINE JWRGBColor
JWRGBColorMake(CGFloat red, CGFloat green, CGFloat blue) {
    JWRGBColor color;
    color.red = red;
    color.green = green;
    color.blue = blue;
    return color;
}

