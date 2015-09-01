//
//  PopDivideLines.m
//  Pop
//
//  Created by LuHaoPeng on 星期五-8-28.
//  Copyright (c) 2015年 LuHaopeng. All rights reserved.
//

#import "PopDivideLines.h"

// ---------------------------------------------
#pragma mark - PointTuple
// PointTuple is the support class of DivideLineDrawer.
// It's used to describe the two ends of a line.
// ---------------------------------------------

@interface PointTuple : NSObject 
@property (nonatomic, assign) CGPoint left;
@property (nonatomic, assign) CGPoint right;
@end

@implementation PointTuple
@synthesize left = _left;
@synthesize right = _right;

- (instancetype)init {
  if (self = [super init]) {
    _left = CGPointZero;
    _right = CGPointZero;
  }
  return self;
}

@end

// ---------------------------------------------
#pragma mark - DivideLineDrawer
// DivideLineDrawer
// ---------------------------------------------

@interface PopDivideLines ()
@property (nonatomic, strong) NSMutableArray *tuples;
@property (nonatomic, strong) void (^withdrawCompletion)(void);
@end

@implementation PopDivideLines
@synthesize superView = _superView;

#pragma mark - instantiate

+ (PopDivideLines *)linesWithPercentageOfParts:(NSArray *)parts inView:(UIView *)view {
  PopDivideLines *lines = [[PopDivideLines alloc] init];
  lines.superView = view;
  lines.percentageOfParts = parts;
  return lines;
}

- (instancetype)init {
  if (self = [super init]) {
    // initialize default values
    [self setStrokeColor:[UIColor grayColor].CGColor];
    [self setFillColor:[UIColor clearColor].CGColor];
    [self setLineWidth:0.3];
    _enterDuration = 1.0;
    _exitDuration = 1.0;
    _lineLengthFactor = 0.875;
    _tuples = [[NSMutableArray alloc] initWithCapacity:5];
  }
  return self;
}

#pragma mark - drawing

- (void)draw {
  [self prepareForDrawing];
  [self setStrokeEnd:1.0f];
  CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  pathAnimation.duration = _enterDuration;
  pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
  pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
  [self addAnimation:pathAnimation forKey:@"strokeEnd"];
}

- (void)withDraw:(void (^)(void))completion {
  _withdrawCompletion = completion;
  [self setStrokeEnd:0.0f];
  CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  pathAnimation.duration = _exitDuration;
  pathAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
  pathAnimation.toValue = [NSNumber numberWithFloat:0.0f];
  pathAnimation.delegate = self;
  [self addAnimation:pathAnimation forKey:@"strokeEnd"];
}

- (void)prepareForDrawing {
  // clear tuples
  [_tuples removeAllObjects];
  
  // analyze percentage, and construct point tuple
  CGFloat percentFromTop = 0;
  for (NSNumber *percent in _percentageOfParts) {
    percentFromTop += percent.floatValue;
    PointTuple *tuple = [[PointTuple alloc] init];
    tuple.left = CGPointMake(_superView.frame.size.width * (1 - _lineLengthFactor) * 0.5, _superView.frame.size.height * percentFromTop);
    tuple.right = CGPointMake(_superView.frame.size.width * (1 + _lineLengthFactor) * 0.5, _superView.frame.size.height * percentFromTop);
    [_tuples addObject:tuple];
  }
  
  // for each tuple, add a line to connect the two ends
  UIBezierPath *lines = [UIBezierPath bezierPath];
  for (PointTuple *tuple in _tuples) {
    [lines moveToPoint:tuple.left];
    [lines addLineToPoint:tuple.right];
  }
  
  // set lines to be the path of self
  self.path = lines.CGPath;
  
  // add self to superView's subLayers
  [_superView.layer addSublayer:self];
}

#pragma mark - animation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  [self removeFromSuperlayer];
  _withdrawCompletion();
}

@end
