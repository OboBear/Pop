//
//  PopDivideLines.h
//  Pop
//
//  Created by LuHaoPeng on 星期五-8-28.
//  Copyright (c) 2015年 LuHaopeng. All rights reserved.
//

@import QuartzCore;
@import UIKit;

@interface PopDivideLines : CAShapeLayer

@property (nonatomic, strong) UIView *superView;          //!< the superView that `PopDivideLines` will be drawn in.
@property (nonatomic, strong) NSArray *percentageOfParts; //!< the parts defined in percentage that `PopDivideLines` will be drawn into.
@property (nonatomic, assign) CGFloat enterDuration;      //!< animation enter duration. Defaults to 1.0
@property (nonatomic, assign) CGFloat exitDuration;       //!< animation exit duration. Defaults to 1.0
@property (nonatomic, assign) CGFloat lineLengthFactor;    //!< the percentage that `PopDivideLines` takes of the superView's width. Defaults to 0.875

/**
 @brief Initialize a `PopDivideLines` with given percentage of parts.
 @param parts an `NSArray` with heights of parts(in percentage), excluding the last part.
 @param view the superView that `PopDivideLines` will be drawn in.
 @return a `PopDivideLines` object.
 */
+ (PopDivideLines *)linesWithPercentageOfParts:(NSArray *)parts inView:(UIView *)view;

/** 
 @brief start animations;
 
 Any additional settings should be done before this being called
 */
- (void)draw;

/// quiting animations
- (void)withDraw:(void (^)(void))completion;

@end
