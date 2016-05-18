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


/*会到前一个ViewController*/
-(void)GoBackToFormerViewController;

/*显示下一个ViewController*/
-(void)displayNextVC:(UIViewController *)nextViewController;

-(void)pushViewControllerToRootNavgationController:(UIViewController *)viewController;

-(void)setRootNavigationBarHidden:(BOOL)hidden;
@end
