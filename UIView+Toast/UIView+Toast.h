//
//  UIView+Toast.h
//  BigEvent
//
//  Created by XiongMacAir on 15/4/21.
//  Copyright (c) 2015年 XiongMacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Toast)


/*将一个View以Toast的方式从某个view的位置上显示出来*/
-(void)ToastFromPostionOfView:(UIView *)view;

/*将一个View以淡入淡出Toast的方式从某个view的位置上显示出来*/
-(void)FadeToastFromView:(UIView *)view;

/*将一个View以淡出并放大尺寸的方式，从另一个View的位置上行显示出来*/
-(void)FadeAndScaleToLargerToastFromView:(UIView *)view;
@end
