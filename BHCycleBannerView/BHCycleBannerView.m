//
//  BHCycleBannerView.m
//  PagedScrollView
//
//  Created by XiongMacAir on 15-5-30.
//  Copyright (c) 2015年 Apple Inc. All rights reserved.
//

#import "BHCycleBannerView.h"
#import "NSTimer+Addition.h"

@interface BHCycleBannerView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) NSTimer *animationTimer;

@end

@implementation BHCycleBannerView

-(void)reloadData{
    
    if (_totalPagesCount) {
        _totalPageCount = _totalPagesCount();
    }
    else
    {
        _totalPageCount = 0;
    }
    
    [self configContentViews];

    
    if (_totalPageCount) {
        [_animationTimer invalidate];
        
        static int count = 0;
        
        
        NSLog(@"_animationTimer = %d",count);
        
        count++;

//        _animationTimer = nil;
        if (_animationDuration > 0 && _animationTimer == nil) {
            _animationTimer = [NSTimer scheduledTimerWithTimeInterval:_animationDuration target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:YES];
            
            
        }
    }
}


-(UIView *)dequeueReusableUnitView
{
    UIView *view = nil;
    
    view = [reuseViewSet anyObject];
    
    if (view) {
        [reuseViewSet removeObject:view];
    }
#ifdef DEBUG
    
//    NSLog(@"reuseViewSet = %@ \n \n",reuseViewSet);
    
#endif

    return view;
}

-(void)setOnScrollToIndexBlock:(void (^)(NSInteger index,UIView *focusView))block
{
    onScrollToIndexBlock = block;
}



-(void)setAnimationDuration:(NSTimeInterval)animationDuration{
    
    [_animationTimer invalidate];
    
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:(_animationDuration = animationDuration)
                                                           target:self
                                                         selector:@selector(animationTimerDidFired:)
                                                         userInfo:nil
                                                          repeats:YES];
    [_animationTimer pauseTimer];
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    _animationDuration = animationDuration;
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//        _scrollView.autoresizingMask = 0xFF;
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(_scrollView.frame), 10.0f);
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        _currentPageIndex = 0;
    }
    return self;
}

-(void)setScrollDuration:(NSTimeInterval)Time
{
    _animationDuration = Time;
}
-(void)awakeFromNib{
    if (_scrollView == nil) {
        self.autoresizesSubviews = YES;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        //        _scrollView.autoresizingMask = 0xFF;
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(_scrollView.frame), 10.0f);
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        _currentPageIndex = 0;        
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(_scrollView.frame), _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
    NSLog(@"%@",_scrollView);
}

-(void)scrollToIndex:(NSInteger)index
{
    _currentPageIndex = index;
    [self configContentViews];
}

- (void)configContentViews
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in _contentViews) {
        contentView.userInteractionEnabled = YES;
        if (contentView.gestureRecognizers.count == 0) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
            [contentView addGestureRecognizer:tapGesture];
        }
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(_scrollView.frame) * (counter ++), 0);
        
        contentView.frame = rightRect;
        [_scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}
/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + 1];
    if (_contentViews == nil) {
        _contentViews = [NSMutableArray new];
    }
    
    //将当前ContentView当中的内容，添加到重用集合当中
    
    if (reuseViewSet == nil) {
        reuseViewSet = [NSMutableSet new];
    }
    [reuseViewSet addObjectsFromArray:_contentViews];
    
    [_contentViews removeAllObjects];
    
    if (_fetchContentViewAtIndex) {
        
        UIView *view = _fetchContentViewAtIndex(previousPageIndex,[self dequeueReusableUnitView]);
        [_contentViews addObject:view];
        view.tag = previousPageIndex;
        
        view = _fetchContentViewAtIndex(_currentPageIndex,[self dequeueReusableUnitView]);
        [_contentViews addObject:view];
        view.tag = _currentPageIndex;
        
        view = _fetchContentViewAtIndex(rearPageIndex,[self dequeueReusableUnitView]);
        [_contentViews addObject:view];
        view.tag = rearPageIndex;
        
        view.tag = rearPageIndex;
        for (UIView *view in _contentViews) {
            view.bounds = self.bounds;
        }
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return _totalPageCount - 1;
    } else if (currentPageIndex == _totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始拖拽");
    [_animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"停止拖拽");
    [_animationTimer resumeTimerAfterTimeInterval:_animationDuration];
}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//
//}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (onScrollToIndexBlock) {
        onScrollToIndexBlock(_currentPageIndex,[scrollView viewWithTag:_currentPageIndex]);
    
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        _currentPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + 1];
        [self configContentViews];
        //将滚动到某一行的消息传递出去
        if (onScrollToIndexBlock) {
            onScrollToIndexBlock(_currentPageIndex,[scrollView viewWithTag:_currentPageIndex]);
        }
    }
    if(contentOffsetX <= 0) {
        _currentPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex - 1];
        [self configContentViews];
        //将滚动到某一行的消息传递出去
        if (onScrollToIndexBlock) {
            onScrollToIndexBlock(_currentPageIndex,[scrollView viewWithTag:_currentPageIndex]);
        }
    }
}

- (void)animationTimerDidFired:(NSTimer *)timer
{
    
    NSInteger currentOffSetIndex = _scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame);
    
    
    CGPoint newOffset = CGPointMake((currentOffSetIndex + 1) * CGRectGetWidth(_scrollView.frame), _scrollView.contentOffset.y);
    
    
    
    [_scrollView setContentOffset:newOffset animated:YES];
}


- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (_TapActionBlock) {
        _TapActionBlock(_currentPageIndex,tap.view);
    }
}


@implementation NSTimer (Addition)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
