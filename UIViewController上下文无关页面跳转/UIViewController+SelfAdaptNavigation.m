//
//  UIViewController+_SelfAdaptNavigation.m
//  BigEvent
//
//  Created by XiongMacAir on 15/4/14.
//  Copyright (c) 2015年 XiongMacAir. All rights reserved.
//

#import "UIViewController+SelfAdaptNavigation.h"

@implementation UIViewController (SelfAdaptNavigation)

-(void)GoBackToFormerViewController
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)displayNextVC:(UIViewController *)nextViewController
{
    
    if(self.navigationController)
    {
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    else
    {
        [self pushViewControllerToRootNavgationController:nextViewController];
    }
    
}

-(void)pushViewControllerToRootNavgationController:(UIViewController *)viewController
{
   UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([navController isKindOfClass:[UINavigationController class]]) {
        //如果RootViewController确实是NavigationController，便push进去
        [navController pushViewController:viewController animated:YES];
    }
    else
    {
        //若不是,则只好present出来了
        if (self.presentedViewController) {
            //若当前已经呈现出一个ViewController，则先将其消失，再显示该ViewController
            __weak UIViewController *wself = self;
            [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
                [wself presentViewController:viewController animated:YES completion:nil];
            }];
        }
        else
        {
            //否则直接显示出来
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
}

-(void)replaceSelfByViewController:(UIViewController *)viewController
{
    if (self.navigationController) {
        [self.navigationController pushViewControllerAfterPop:viewController];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.presentingViewController presentViewController:viewController animated:YES completion:nil];
        }];
    }
}

-(void)setRootNavigationBarHidden:(BOOL)hidden
{
    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;

    if ([navController isKindOfClass:[UINavigationController class]]) {
        navController.navigationBarHidden = hidden;
    }
}

@end

@interface UINavigationController (GobackAndShowAnotherViewController)
-(void)pushViewControllerAfterPop:(UIViewController *)viewController
{
    [self popViewControllerAnimated:NO];
    [self pushViewController:viewController animated:YES];
}

@end

