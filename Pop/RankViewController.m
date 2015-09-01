//
//  RankViewController.m
//  Pop
//
//  Created by LuHaoPeng on 星期五-8-28.
//  Copyright (c) 2015年 LuHaopeng. All rights reserved.
//

#import "RankViewController.h"

// section height factor
#define kTopSectionHeightFactor 0.19
#define kBodySectionHeightFactor 0.64
#define kBottomSectionHeightFactor 0.17

@implementation RankViewController

#pragma mark - life cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated {
  [self enterAnimations];
}

#pragma mark - views and animations

- (void)drawViews {
  CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
  
  // add divideLines
  _divideLines = [PopDivideLines linesWithPercentageOfParts:[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:kTopSectionHeightFactor], [NSNumber numberWithFloat:kBodySectionHeightFactor], nil] inView:self.view];
  [_divideLines setLineWidth:kDivideLineWidth];
//  [_divideLines setEnterDuration:kEnterDuration];
  [_divideLines setExitDuration:kExitDuration];
  
  // add top label
  _topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  _topLabel.text = @"排行";
  [_topLabel setFont:[UIFont systemFontOfSize:36]];
  [_topLabel sizeToFit];
  _topLabel.center = CGPointMake(screenFrame.size.width / 2.0, screenFrame.size.height * kTopSectionHeightFactor / 2.0 - kSectionInitialDistance);
  [self.view addSubview:_topLabel];
  
  // add bottom button
  _bottomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   _bottomButton.backgroundColor = [UIColor colorWithRed:0.15 green:0.62 blue:0.50 alpha:1.0];
  [_bottomButton setBackgroundImage:[UIImage imageNamed:@"OKButton_BG"] forState:UIControlStateNormal];
  CGSize size = [_bottomButton sizeThatFits:CGSizeMake(80, 35)];
  [_bottomButton setFrame:CGRectMake((screenFrame.size.width - size.width) / 2.0, screenFrame.size.height * (1 - 0.5 * kBottomSectionHeightFactor) - size.height / 2.0 + kSectionInitialDistance, size.width, size.height)];
  _bottomButton.layer.cornerRadius = 5.0;
  _bottomButton.clipsToBounds = YES;
  [_bottomButton setTitle:@"好" forState:UIControlStateNormal];
  [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  _bottomButton.reversesTitleShadowWhenHighlighted = YES;
  [_bottomButton addTarget:self action:@selector(didTouchButton:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_bottomButton];
  
  // add scrollView
  // scrollView is designed with 0.8 * BodyWidth & 0.9 * BodyHeight, in the middle of BodyFrame.
  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(1.1 * screenFrame.size.width, (0.05 * kBodySectionHeightFactor + kTopSectionHeightFactor) * screenFrame.size.height, 0.8 * screenFrame.size.width, 0.9 * kBodySectionHeightFactor * screenFrame.size.height)];
  _scrollView.pagingEnabled = YES;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.contentSize = CGSizeMake(0.85 * 2 * _scrollView.frame.size.width, _scrollView.bounds.size.height);
  [self.view addSubview:_scrollView];
  
  // Mode Icons in scrollView
  CGFloat iconWidth = 0.14 * 0.85 * _scrollView.frame.size.width;
  UIImageView *timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time"]];
  timeIcon.frame = CGRectMake(0, 0, iconWidth, iconWidth);
  timeIcon.center = CGPointMake(0.85 * _scrollView.frame.size.width / 2.0, 5 + iconWidth / 2.0);
  timeIcon.layer.cornerRadius = 5.0;
  timeIcon.clipsToBounds = YES;
  [_scrollView addSubview:timeIcon];
  
  UIImageView *moveIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"move"]];
  moveIcon.frame = CGRectMake(0, 0, iconWidth, iconWidth);
  moveIcon.center = CGPointMake(1.5 * 0.85 * _scrollView.frame.size.width, 5 + iconWidth / 2.0);
  moveIcon.layer.cornerRadius = 5.0;
  moveIcon.clipsToBounds = YES;
  [_scrollView addSubview:moveIcon];
  
  // Vertical parting line in scrollView
  UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0.85 * _scrollView.frame.size.width, 0.1 * _scrollView.frame.size.height, kDivideLineWidth, 0.8 * _scrollView.frame.size.height)];
  verticalLine.backgroundColor = [UIColor grayColor];
  [_scrollView addSubview:verticalLine];
}

- (void)enterAnimations {
  // animations for divideLines
  [_divideLines draw];
  
  // animations for top label
  [UIView animateWithDuration:kEnterDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    _topLabel.center = CGPointMake(_topLabel.center.x, _topLabel.center.y + kSectionInitialDistance);
  } completion:nil];
  
  // animations for bottom button
  [UIView animateWithDuration:kEnterDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    [_bottomButton setFrame:CGRectMake(_bottomButton.frame.origin.x, _bottomButton.frame.origin.y - kSectionInitialDistance, _bottomButton.frame.size.width, _bottomButton.frame.size.height)];
  } completion:nil];
  
  CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];

  // animations for scrollView
  [UIView animateWithDuration:kEnterDuration delay:0.3 usingSpringWithDamping:0.7 initialSpringVelocity:(1 / kEnterDuration) options:UIViewAnimationOptionCurveEaseInOut animations:^{
    [_scrollView setFrame:CGRectMake(_scrollView.frame.origin.x - screenFrame.size.width, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height)];
  } completion:nil];
}

- (void)withdrawAnimations:(void (^)(void))completion {
  __block int retainCount = 4;
  // animations for divideLines
  [_divideLines withDraw:^{
    if (retainCount == 1) { // this is the last one holding RankVC
      completion();
    } else {
      retainCount--;
    }
  }];
  
  // animations for top label
  [UIView animateWithDuration:kExitDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    _topLabel.center = CGPointMake(_topLabel.center.x, _topLabel.center.y - kSectionInitialDistance);
  } completion:^(BOOL finished) {
    if (retainCount == 1) { // this is the last one holding RankVC
      completion();
    } else {
      retainCount--;
    }
  }];
  
  // animations for bottom button
  [UIView animateWithDuration:kExitDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    [_bottomButton setFrame:CGRectMake(_bottomButton.frame.origin.x, _bottomButton.frame.origin.y + kSectionInitialDistance, _bottomButton.frame.size.width, _bottomButton.frame.size.height)];
  } completion:^(BOOL finished) {
    if (retainCount == 1) { // this is the last one holding RankVC
      completion();
    } else {
      retainCount--;
    }
  }];
  
  // animations for scrollView
  [UIView animateWithDuration:kExitDuration delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    [_scrollView setFrame:CGRectMake(_scrollView.frame.origin.x + _scrollView.frame.size.width, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height)];
  } completion:^(BOOL finished) {
    if (retainCount == 1) { // this is the last one holding RankVC
      completion();
    } else {
      retainCount--;
    }
  }];
}

#pragma mark - touch action

- (void)didTouchButton:(UIButton *)sender {
  [self withdrawAnimations:^{
    [self dismissViewControllerAnimated:NO completion:nil];
  }];  
}

@end
