//
//  UIView+Toast.m
//  BigEvent
//
//  Created by XiongMacAir on 15/4/21.
//  Copyright (c) 2015年 XiongMacAir. All rights reserved.
//

#import "UIView+Toast.h"

@implementation UIView (Toast)


-(void)ToastFromPostionOfView:(UIView *)view
{
    CGPoint centerInWindow = [view.superview convertPoint:view.center toView:[UIApplication sharedApplication].keyWindow];
    self.center = centerInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    __weak UIView *wself = self;
    [UIView animateWithDuration:1.0 animations:^{
        wself.frame = CGRectMake(wself.frame.origin.x + 50.0f, wself.frame.origin.y  - 50.0f, wself.frame.size.width, wself.frame.size.height);
        wself.alpha = 0.0f;
        wself.transform = CGAffineTransformScale(CGAffineTransformIdentity,2.0F,2.0F);
    } completion:^(BOOL finished) {
        [wself removeFromSuperview];
    }];
}

-(void)FadeToastFromView:(UIView *)view
{
    CGPoint centerInWindow = [view.superview convertPoint:view.center toView:[UIApplication sharedApplication].keyWindow];
    self.center = centerInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    __weak UIView *wself = self;
    [UIView animateWithDuration:1.0 animations:^{
        wself.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [wself removeFromSuperview];
    }];

}

-(void)FadeAndScaleToLargerToastFromView:(UIView *)view
{
    CGPoint centerInWindow = [view.superview convertPoint:view.center toView:[UIApplication sharedApplication].keyWindow];
    self.center = centerInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    __weak UIView *wself = self;
    [UIView animateWithDuration:1.0 animations:^{
        wself.frame = CGRectMake(wself.frame.origin.x + 50.0f, wself.frame.origin.y  - 50.0f, wself.frame.size.width, wself.frame.size.height);
        wself.alpha = 0.0f;
        wself.transform = CGAffineTransformScale(CGAffineTransformIdentity,2.0F,2.0F);
    } completion:^(BOOL finished) {
        [wself removeFromSuperview];
    }];
}
@end
