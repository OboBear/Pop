//
//  PopToolBar.h
//  Pop
//
//  Created by LuHaoPeng on 星期一-8-24.
//  Copyright (c) 2015年 LuHaopeng. All rights reserved.
//

@import UIKit;

@protocol PopToolBarDelegate;

@interface PopToolBar : UIView

@property (nonatomic, strong) id <PopToolBarDelegate> delegate;
@property (nonatomic, assign) CGFloat enterDuration;      //!< Animation enter duration. Defaults to 1.0
@property (nonatomic, assign) CGFloat exitDuration;       //!< Animation exit duration. Defaults to 1.0
@property (nonatomic, assign) CGFloat itemInterval;       //!< The distance between each item. Defaults to 50.0

/**
 The distance below superView's bottom edge on init. 
 
 Defaults to 200.0, combined with 1.43 for `enterVelocity`.
 */
@property (nonatomic, assign) CGFloat itemInitDistance;

/**
 The damping ratio for the spring animation as it approaches its quiescent state.
 
 To smoothly decelerate the animation without oscillation, use a value of 1. Employ a damping ratio closer to zero to increase oscillation.
 
 Defaults to 0.7
 */
@property (nonatomic, assign) CGFloat enterDamping;

/**
 The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment.
 
 A value of 1 corresponds to the total animation distance traversed in one second. For example, if the total animation distance is 200 points and you want the start of the animation to match a view velocity of 100 pt/s, use a value of 0.5.
 
 Defaults to 1.43, combined with 200.0 for `itemInitDistance`.
 */
@property (nonatomic, assign) CGFloat enterVelocity;

@property (nonatomic, assign) CGFloat itemAnimationDelay; //!< The delay seconds after the former item started. Defaults to 0.1s.

/// entering animations
- (void)draw;

/// withdrawing animations
- (void)withdraw:(void (^)(void))completion;

@end

// ---------------------------------
// PopToolBarDelegate
// ---------------------------------

@protocol PopToolBarDelegate <NSObject>

/**
 @brief Called when user clicked on the toolBar
 @param toolbar the inferred `PopToolBar` object
 @param itemIndex 0 for rank, 1 for info, 2 for setting
 */
- (void)toolbar:(PopToolBar *)toolbar ItemClickedAtIndex:(NSInteger)itemIndex;

@end