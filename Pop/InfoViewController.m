//
//  InfoViewController.m
//  Pop
//
//  Created by LuHaoPeng on 星期二-9-1.
//  Copyright (c) 2015年 LuHaopeng. All rights reserved.
//

#import "InfoViewController.h"

// section height factor
#define kTopSectionHeightFactor 0.19
#define kBodySectionHeightFactor 0.64
#define kBottomSectionHeightFactor 0.17

@implementation InfoViewController

#pragma mark - life cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  // set the display strings
  self.authorInfo = @"昵称：小明\n微博：@让大熊抱你一下\n手机：15757115324\n邮箱：851987262@qq.com\nlhp0324@gmail.com";
  self.purpose = @"啊，就是为了填个坑。。\n去年5月份的坑。。\n下面是被迫加上的话：\n-\n-\n-\n-\n嗯，我姐姐是个（以下省略31个汉字，解锁完整版以查看全部ψ(｀∇´)ψ ）\n"; // 嗯，我姐姐是个温柔善良的美丽女生，对我非常宠爱，我也很爱我姐姐，因为她颜值高，又善良
  self.versionInfo = @"- v1.0\n第一版嘛，当然什么更新信息都还没有。。";
  
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
  _topLabel.text = @"关于";
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
  _scrollView.showsHorizontalScrollIndicator = NO;
  // 0.85 is the percentage that the content's width takes in scrollView.
  CGFloat contentPageWidth = 0.85 * _scrollView.frame.size.width;
  // 3 is the count of pages in scrollView's content.
  _scrollView.contentSize = CGSizeMake(3 * contentPageWidth, _scrollView.bounds.size.height);
  [self.view addSubview:_scrollView];
  
  // page labels for scrollView's content
  CGFloat labelTopMargin = 20.0;
  UILabel *firstPageTitle = [[UILabel alloc] initWithFrame:CGRectZero];
  firstPageTitle.text = @"作者";
  [firstPageTitle setFont:[UIFont systemFontOfSize:19]];
  [firstPageTitle sizeToFit];
  firstPageTitle.center = CGPointMake(0.5 * contentPageWidth, labelTopMargin);
  [_scrollView addSubview:firstPageTitle];
  
  UILabel *secondPageTitle = [[UILabel alloc] initWithFrame:CGRectZero];
  secondPageTitle.text = @"目的";
  [secondPageTitle setFont:[UIFont systemFontOfSize:19]];
  [secondPageTitle sizeToFit];
  secondPageTitle.center = CGPointMake(1.5 * contentPageWidth, labelTopMargin);
  [_scrollView addSubview:secondPageTitle];
  
  UILabel *thirdPageTitle = [[UILabel alloc] initWithFrame:CGRectZero];
  thirdPageTitle.text = @"版本摘要";
  [thirdPageTitle setFont:[UIFont systemFontOfSize:19]];
  [thirdPageTitle sizeToFit];
  thirdPageTitle.center = CGPointMake(2.5 * contentPageWidth, labelTopMargin);
  [_scrollView addSubview:thirdPageTitle];
  
  // Vertical parting line in scrollView
  UIView *verticalLine1 = [[UIView alloc] initWithFrame:CGRectMake(contentPageWidth, 0.1 * _scrollView.frame.size.height, kDivideLineWidth, 0.8 * _scrollView.frame.size.height)];
  verticalLine1.backgroundColor = [UIColor grayColor];
  [_scrollView addSubview:verticalLine1];
  
  UIView *verticalLine2 = [[UIView alloc] initWithFrame:CGRectMake(2 * contentPageWidth, 0.1 * _scrollView.frame.size.height, kDivideLineWidth, 0.8 * _scrollView.frame.size.height)];
  verticalLine2.backgroundColor = [UIColor grayColor];
  [_scrollView addSubview:verticalLine2];
  
  // Text
  CGFloat textTopMargin = 60.0;
  CGSize textSize = CGSizeMake(0.82 * contentPageWidth, 0.68 * _scrollView.frame.size.height);
  UITextView *firstPageText = [[UITextView alloc] initWithFrame:CGRectMake(0, textTopMargin, textSize.width, textSize.height)];
  firstPageText.center = CGPointMake(0.5 * contentPageWidth, firstPageText.center.y);
  firstPageText.text = _authorInfo;
  [firstPageText setFont:[UIFont systemFontOfSize:14]];
//  firstPageText.textAlignment = NSTextAlignmentCenter;
  firstPageText.textColor = [UIColor blackColor];
  firstPageText.editable = NO;
  firstPageText.selectable = YES;
  [_scrollView addSubview:firstPageText];
  
  UITextView *secondPageText = [[UITextView alloc] initWithFrame:CGRectMake(0, textTopMargin, textSize.width, textSize.height)];
  secondPageText.center = CGPointMake(1.5 * contentPageWidth, secondPageText.center.y);
  secondPageText.text = _purpose;
  [secondPageText setFont:[UIFont systemFontOfSize:14]];
//  secondPageText.textAlignment = NSTextAlignmentCenter;
  secondPageText.textColor = [UIColor blackColor];
  secondPageText.editable = NO;
  secondPageText.selectable = YES;
  [_scrollView addSubview:secondPageText];
  
  UITextView *thirdPageText = [[UITextView alloc] initWithFrame:CGRectMake(0, textTopMargin, textSize.width, textSize.height)];
  thirdPageText.center = CGPointMake(2.5 * contentPageWidth, thirdPageText.center.y);
  thirdPageText.text = _versionInfo;
  [thirdPageText setFont:[UIFont systemFontOfSize:14]];
//  thirdPageText.textAlignment = NSTextAlignmentCenter;
  thirdPageText.textColor = [UIColor blackColor];
  thirdPageText.editable = NO;
  thirdPageText.selectable = YES;
  [_scrollView addSubview:thirdPageText];
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
  [UIView animateWithDuration:kExitDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    _topLabel.center = CGPointMake(_topLabel.center.x, _topLabel.center.y - kSectionInitialDistance);
  } completion:^(BOOL finished) {
    if (retainCount == 1) { // this is the last one holding RankVC
      completion();
    } else {
      retainCount--;
    }
  }];
  
  // animations for bottom button
  [UIView animateWithDuration:kExitDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    [_bottomButton setFrame:CGRectMake(_bottomButton.frame.origin.x, _bottomButton.frame.origin.y + kSectionInitialDistance, _bottomButton.frame.size.width, _bottomButton.frame.size.height)];
  } completion:^(BOOL finished) {
    if (retainCount == 1) { // this is the last one holding RankVC
      completion();
    } else {
      retainCount--;
    }
  }];
  
  // animations for scrollView
  [UIView animateWithDuration:kExitDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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
