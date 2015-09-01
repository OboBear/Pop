//
//  PopToolBar.m
//  Pop
//
//  Created by LuHaoPeng on 星期一-8-24.
//  Copyright (c) 2015年 LuHaopeng. All rights reserved.
//

#import "PopToolBar.h"

// item width factor
#define kItemWidthFactor 10.0

@interface PopToolBar ()

@property (nonatomic, strong) UIImageView *rankItem;   //!< the rank item with index 0
@property (nonatomic, strong) UIImageView *infoItem;   //!< the info item with index 1
@property (nonatomic, strong) UIImageView *settingItem;//!< the setting item with index 2

@property (nonatomic) CGRect barFrame;            //!< the toolbar's frame
@property (nonatomic) CGFloat itemWidth;          //!< the toolbar items' width

@end

@implementation PopToolBar

- (instancetype)init {
  self = [self initWithFrame:CGRectMake(0, 420, 320, 60)]; // default, designed for iPhone 4
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setBackgroundColor:[UIColor clearColor]];
    [self setUserInteractionEnabled:YES];
    _barFrame = frame;
    _itemWidth = frame.size.width / kItemWidthFactor;
    _enterDuration = 1.0;
    _exitDuration = 1.0;
    _itemInitDistance = 200;
    _itemInterval = 50.0;
    _enterDamping = 0.7;
    _enterVelocity = 1.43;
    _itemAnimationDelay = 0.1;
  }
  return self;
}

- (void)removeViews {
  _rankItem = nil;
  _infoItem = nil;
  _settingItem = nil;
  
  [_rankItem removeFromSuperview];
  [_infoItem removeFromSuperview];
  [_settingItem removeFromSuperview];
}

#pragma mark - animation

- (void)draw {
  // init frames for items
  _rankItem = [[UIImageView alloc] initWithFrame:CGRectMake(_barFrame.size.width / 2.0 - _itemWidth / 2.0 - _itemInterval, _barFrame.size.height / 2.0 - _itemWidth / 2.0 + _itemInitDistance, _itemWidth, _itemWidth)];
  _infoItem = [[UIImageView alloc] initWithFrame:CGRectMake(_barFrame.size.width / 2.0 - _itemWidth / 2.0, _barFrame.size.height / 2.0 - _itemWidth / 2.0 + _itemInitDistance, _itemWidth, _itemWidth)];
  _settingItem = [[UIImageView alloc] initWithFrame:CGRectMake(_barFrame.size.width / 2.0 - _itemWidth / 2.0 + _itemInterval, _barFrame.size.height / 2.0 - _itemWidth / 2.0 + _itemInitDistance, _itemWidth, _itemWidth)];
  
  // set tags for items: 0 for rank, 1 for info, 2 for setting
  [_rankItem setTag:0];
  [_infoItem setTag:1];
  [_settingItem setTag:2];
  
  // set images for items
  [_rankItem setImage:[UIImage imageNamed:@"bottomRank"]];
  [_infoItem setImage:[UIImage imageNamed:@"bottomInfo"]];
  [_settingItem setImage:[UIImage imageNamed:@"bottomSetting"]];
  
  // set user interaction
  [_rankItem setUserInteractionEnabled:YES];
  [_infoItem setUserInteractionEnabled:YES];
  [_settingItem setUserInteractionEnabled:YES];
  
  // add tap gesture
  UITapGestureRecognizer *tapRank = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnItems:)];
  tapRank.numberOfTapsRequired = 1;
  tapRank.numberOfTouchesRequired = 1;
  UITapGestureRecognizer *tapInfo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnItems:)];
  tapInfo.numberOfTapsRequired = 1;
  tapInfo.numberOfTouchesRequired = 1;
  UITapGestureRecognizer *tapSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnItems:)];
  tapSetting.numberOfTapsRequired = 1;
  tapSetting.numberOfTouchesRequired = 1;


  [_rankItem addGestureRecognizer:tapRank];
  [_infoItem addGestureRecognizer:tapInfo];
  [_settingItem addGestureRecognizer:tapSetting];
  
  [self addSubview:_rankItem];
  [self addSubview:_infoItem];
  [self addSubview:_settingItem];
  
  //---------------------------------------------------------
  
  // animations
  CGFloat initialDelay = 0.2;
  [UIView animateWithDuration:_enterDuration delay:initialDelay usingSpringWithDamping:_enterDamping initialSpringVelocity:_enterVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
    // rank item
    [_rankItem setFrame:CGRectMake(_rankItem.frame.origin.x, _rankItem.frame.origin.y - _itemInitDistance, _itemWidth, _itemWidth)];
  } completion:nil];
  
  [UIView animateWithDuration:_enterDuration delay:initialDelay + _itemAnimationDelay usingSpringWithDamping:_enterDamping initialSpringVelocity:_enterVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
    // info item
    [_infoItem setFrame:CGRectMake(_infoItem.frame.origin.x, _infoItem.frame.origin.y - _itemInitDistance, _itemWidth, _itemWidth)];
  } completion:nil];
  
  [UIView animateWithDuration:_enterDuration delay:initialDelay + 2 * _itemAnimationDelay usingSpringWithDamping:_enterDamping initialSpringVelocity:_enterVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
    // setting item
    [_settingItem setFrame:CGRectMake(_settingItem.frame.origin.x, _settingItem.frame.origin.y - _itemInitDistance, _itemWidth, _itemWidth)];
  } completion:nil];
}

- (void)withdraw:(void (^)(void))completion {
  // universal configuration
  CGFloat initialDelay = 0.1;
  __block int retainCount = 3;
  
  [UIView animateWithDuration:_exitDuration delay:initialDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
    // setting item
    [_settingItem setFrame:CGRectMake(_settingItem.frame.origin.x, _settingItem.frame.origin.y + _itemInitDistance, _itemWidth, _itemWidth)];
  } completion:^(BOOL finished){
    if (finished) {
      if (retainCount == 1) { // this is the last one holding PopToolBar
        [self removeViews];
        completion();
      } else {
        retainCount--;
      }
    }
  }];

  [UIView animateWithDuration:_exitDuration delay:initialDelay + _itemAnimationDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
    // info item
    [_infoItem setFrame:CGRectMake(_infoItem.frame.origin.x, _infoItem.frame.origin.y + _itemInitDistance, _itemWidth, _itemWidth)];
  } completion:^(BOOL finished){
    if (finished) {
      if (retainCount == 1) { // this is the last one holding PopToolBar
        [self removeViews];
        completion();
      } else {
        retainCount--;
      }
    }
  }];
  
  [UIView animateWithDuration:_exitDuration delay:initialDelay + 2 * _itemAnimationDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
    // rank item
    [_rankItem setFrame:CGRectMake(_rankItem.frame.origin.x, _rankItem.frame.origin.y + _itemInitDistance, _itemWidth, _itemWidth)];
  } completion:^(BOOL finished){
    if (finished) {
      if (retainCount == 1) { // this is the last one holding PopToolBar
        [self removeViews];
        completion();
      } else {
        retainCount--;
      }
    }
  }];
}

#pragma mark - action

- (void)tapOnItems:(UITapGestureRecognizer *)tap {
  [_delegate toolbar:self ItemClickedAtIndex:tap.view.tag];
}

@end
