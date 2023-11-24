#import <UIKit/UIKit.h>


#import <UIKit/UIKit.h>

%hook UIScrollView

// Variables to store the initial scrolling speed and direction
static CGFloat initialScrollSpeedX = 0.0;
static CGFloat initialScrollSpeedY = 0.0;

@interface CustomScrollView : UIScrollView

- (void)startContinuousScroll:(UIScrollView *)scrollView;

@end

@implementation CustomScrollView

// Custom method to handle continuous scrolling
- (void)startContinuousScroll:(UIScrollView *)scrollView {
    if (initialScrollSpeedX != 0 || initialScrollSpeedY != 0) {
        CGPoint offset = scrollView.contentOffset;
        offset.x += initialScrollSpeedX / 60.0; // Adjust for horizontal scroll speed
        offset.y += initialScrollSpeedY / 60.0; // Adjust for vertical scroll speed
        [UIView animateWithDuration:1.0/60.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [scrollView setContentOffset:offset];
                         } completion:^(BOOL finished) {
                             if (finished && (initialScrollSpeedX != 0 || initialScrollSpeedY != 0)) {
                                 [self startContinuousScroll:scrollView];
                             }
                         }];
    }
}

@end

// New method for starting continuous scroll on UIScrollView
%new
- (void)startContinuousScrollWithUIScrollView:(UIScrollView *)scrollView {
    CustomScrollView *customScrollView = (CustomScrollView *)scrollView;
    [customScrollView startContinuousScroll:scrollView];
}

// Override the method that handles the end of dragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:scrollView];
        initialScrollSpeedX = velocity.x;
        initialScrollSpeedY = velocity.y;
        [self startContinuousScrollWithUIScrollView:scrollView];
    }
}

// Override the method that handles deceleration
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    [self startContinuousScrollWithUIScrollView:scrollView];
}

// Override touches to handle interruption
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    initialScrollSpeedX = 0.0; // Stop horizontal scrolling on touch
    initialScrollSpeedY = 0.0; // Stop vertical scrolling on touch
    %orig;
}

// Override the method that handles the start of scrolling
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    initialScrollSpeedX = 0.0; // Reset horizontal scrolling speed
    initialScrollSpeedY = 0.0; // Reset vertical scrolling speed
}

%end
