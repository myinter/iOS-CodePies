//
//  UIViewController+_SelfAdaptNavigation.h
//  BigEvent
//
//  Created by XiongMacAir on 15/4/14.
//  Copyright (c) 2015年 XiongMacAir. All rights reserved.
//

#import <UIKit/UIKit.h>
//让ViewController之间的跳转可以无视上下文环境，自适应
@interface UIViewController (SelfAdaptNavigation)
/*返回前一个ViewController*/
-(void)GoBackToFormerViewController;
/*显示下一个ViewController*/
-(void)displayNextVC:(UIViewController *)nextViewController;
/*向最根本地位的NavigationController压一个ViewController*/
-(void)pushViewControllerToRootNavgationController:(UIViewController *)viewController;
/*设置NavigationBar的隐藏和显示*/
-(void)setRootNavigationBarHidden:(BOOL)hidden;
/*将自己当前所处的位置，替换为另一个ViewController*/
-(void)replaceSelfByViewController:(UIViewController *)viewController
@end

@interface UINavigationController (GobackAndShowAnotherViewController)

-(void)pushViewControllerAfterPop:(UIViewController *)viewController;

@end
