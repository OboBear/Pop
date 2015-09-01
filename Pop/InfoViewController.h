//
//  InfoViewController.h
//  Pop
//
//  Created by LuHaoPeng on 星期二-9-1.
//  Copyright (c) 2015年 LuHaopeng. All rights reserved.
//

@import UIKit;
#import "PopDivideLines.h"
#import "Constants.h"

@interface InfoViewController : UIViewController

@property (nonatomic, strong) UILabel *topLabel;          //!< The top label with "About" on it.
@property (nonatomic, strong) PopDivideLines *divideLines;//!< Divide lines, literally.
@property (nonatomic, strong) UIScrollView *scrollView;   //!< The body of `InfoViewController`. Displays history records on the lists.
@property (nonatomic, strong) UIButton *bottomButton;     //!< An OK-button to exit `InfoViewController`.

@property (nonatomic, copy) NSString *authorInfo; //!< Displayed in the scrollView's first page.
@property (nonatomic, copy) NSString *purpose;    //!< Displayed in the scrollView's second page.
@property (nonatomic, copy) NSString *versionInfo;//!< Displayed in the scrollView's third page.

@end
