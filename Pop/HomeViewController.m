//
//  HomeViewController.m
//  Pop
//
//  Created by LuHaoPeng on 星期五-8-21.
//  Copyright (c) 2015年 LuHaopeng. All rights reserved.
//

#import "HomeViewController.h"
#import "RankViewController.h"

// section height factor
#define kTopSectionHeightFactor 0.3
#define kBodySectionHeightFactor 0.55
#define kBottomSectionHeightFactor 0.15

@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated {
  [self enterAnimations];
}

- (void)drawViews {
  CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
  
  // add toolbar
  _toolbar = [[PopToolBar alloc] initWithFrame:CGRectMake(0, screenFrame.origin.y + screenFrame.size.height * (1 - kBottomSectionHeightFactor), screenFrame.size.width, screenFrame.size.height * kBottomSectionHeightFactor)];
  [_toolbar setDelegate:self];
  [_toolbar setEnterDuration:kEnterDuration];
  [_toolbar setExitDuration:kExitDuration];
  [self.view addSubview:_toolbar];
  
  // add top label
  CGFloat topLabelWidth = 210.0;
  CGFloat topLabelHeight = 60.0;  // appTitle's initial size
  CGRect topLabelFrame = CGRectMake((screenFrame.size.width - topLabelWidth) / 2.0, (screenFrame.size.height * kTopSectionHeightFactor - topLabelHeight) / 2.0 - kSectionInitialDistance, topLabelWidth, topLabelHeight);
  _topLabel = [[UIImageView alloc] initWithFrame:topLabelFrame];
  [_topLabel setImage:[UIImage imageNamed:@"appTitle"]];
  [self.view addSubview:_topLabel];
  
  // add divideLines
  _divideLines = [PopDivideLines linesWithPercentageOfParts:[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:kTopSectionHeightFactor], [NSNumber numberWithFloat:kBodySectionHeightFactor], nil] inView:self.view];
  [_divideLines setLineWidth:kDivideLineWidth];
//  [_divideLines setEnterDuration:kEnterDuration];
  [_divideLines setExitDuration:kExitDuration];
}

- (void)enterAnimations {
  // animations for top label
  [UIView animateWithDuration:kEnterDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    [_topLabel setFrame:CGRectMake(_topLabel.frame.origin.x, _topLabel.frame.origin.y + kSectionInitialDistance, _topLabel.frame.size.width, _topLabel.frame.size.height)];
  } completion:nil];
  
  // animations for divideLines
  [_divideLines draw];
  
  // animations for toolbar
  [_toolbar draw];
}

- (void)withdrawAnimations:(void (^)(void))completion {
  __block int retainCount = 3;
  // animations for top label
  [UIView animateWithDuration:kEnterDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    [_topLabel setFrame:CGRectMake(_topLabel.frame.origin.x, _topLabel.frame.origin.y - kSectionInitialDistance, _topLabel.frame.size.width, _topLabel.frame.size.height)];
  } completion:^(BOOL finished) {
    if (retainCount == 1) { // this is the last one holding HomeVC
      completion();
    } else {
      retainCount--;
    }
  }];
  
  // animations for divideLines
  [_divideLines withDraw:^{
    if (retainCount == 1) { // this is the last one holding HomeVC
      completion();
    } else {
      retainCount--;
    }
  }];
  
  // animations for toolbar
  [_toolbar withdraw:^{
    if (retainCount == 1) { // this is the last one holding HomeVC
      completion();
    } else {
      retainCount--;
    }
  }];
}

#pragma mark - PopToolBar delegate

- (void)toolbar:(PopToolBar *)toolbar ItemClickedAtIndex:(NSInteger)itemIndex {
  switch (itemIndex) {
    case 0:
    { // <- This pair of braces is required for ARC.
      // It is not necessary to wrap EVERY switch in{}, only those that declare variables (explicitly or via a macro or compiler swizzle). ARC has relatively little to do with it.
      [self withdrawAnimations:^{
        RankViewController *rankVC = [[RankViewController alloc] init];
        [self presentViewController:rankVC animated:NO completion:nil];
      }];
    }
      break;
    case 1:
      break;
    case 2:
      break;
  }
}

@end
