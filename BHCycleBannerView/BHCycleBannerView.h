//
//  BHCycleBannerView.h
//  PagedScrollView
//
//  Created by XiongMacAir on 15-5-30
//  Copyright (c) 2015年 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^OnScrollToIndexBlock)(NSInteger index,UIView *focusView);

@interface BHCycleBannerView : UIView
{
    //滚动到某某个Index对应的View执行的Block
    OnScrollToIndexBlock  onScrollToIndexBlock;
    //单元View的重用集合
    NSMutableSet *reuseViewSet;
}

/*从重用集合中取出一个View*/
-(UIView *)dequeueReusableUnitView;
@property (nonatomic , readonly) UIScrollView *scrollView;

@property (nonatomic , assign,setter=setAnimationDuration:) NSTimeInterval animationDuration;

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

-(void)setScrollDuration:(NSTimeInterval)Time;

-(void)reloadData;
/*数据源Blocks*/
/*返回总页数*/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);
/*获取某一页所需要使用的View*/
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex,UIView *reuseUnitView);
/*某一个View被点击执行的block*/
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex,UIView *tapedView);
/*某一个单元格被滚动到时执行的block*/
-(void)setOnScrollToIndexBlock:(void (^)(NSInteger index,UIView *focusView))block;

@end

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
