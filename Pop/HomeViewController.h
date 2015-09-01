//
//  HomeViewController.h
//  Pop
//
//  Created by LuHaoPeng on 星期五-8-21.
//  Copyright (c) 2015年 LuHaopeng. All rights reserved.
//

@import UIKit;
#import "PopToolBar.h"
#import "PopDivideLines.h"
#import "Constants.h"

@interface HomeViewController : UIViewController <PopToolBarDelegate>

@property (nonatomic, strong) UIImageView *topLabel;
@property (nonatomic, strong) PopToolBar *toolbar;
@property (nonatomic, strong) PopDivideLines *divideLines;

@end

