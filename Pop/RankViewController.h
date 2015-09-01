//
//  RankViewController.h
//  Pop
//
//  Created by LuHaoPeng on 星期五-8-28.
//  Copyright (c) 2015年 LuHaopeng. All rights reserved.
//

@import UIKit;
#import "PopDivideLines.h"
#import "Constants.h"

@interface RankViewController : UIViewController

@property (nonatomic, strong) UILabel *topLabel;          //!< The top label with "Rank" on it.
@property (nonatomic, strong) PopDivideLines *divideLines;//!< Divide lines, literally.
@property (nonatomic, strong) UIScrollView *scrollView;   //!< The body of `RankViewController`. Displays history records on the lists.
@property (nonatomic, strong) UIButton *bottomButton;     //!< An OK-button to exit `RankViewController`.

@end
