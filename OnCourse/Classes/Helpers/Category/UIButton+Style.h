//
//  UIButton+Style.h
//  OnCourse
//
//  Created by Ngoc-Nhan Nguyen on 1/2/13.
//  Copyright (c) 2013 phatle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Style)

+ (UIButton *)buttonBigWithDarkBackgroundStyleAndTitle:(NSString *)title;
+ (UIButton *)buttonSmallWithDarkBackgroundStyleAndTitle:(NSString *)title;
+ (UIButton *)buttonWithBackStyleAndTitle:(NSString *)title;
@end
