#import <UIKit/UIKit.h>

// Variables to store the initial scrolling speed and direction
static CGFloat initialScrollSpeedX = 0.0;
static CGFloat initialScrollSpeedY = 0.0;

// Category on UIScrollView to add the custom method
@interface UIScrollView (ContinuousScroll)

- (void)startContinuousScroll;

@end

@implementation UIScrollView (ContinuousScroll)

// Custom method to handle continuous scrolling
- (void)startContinuousScroll {
    if (initialScrollSpeedX != 0 || initialScrollSpeedY != 0) {
        CGPoint offset = self.contentOffset;
        offset.x += initialScrollSpeedX / 60.0; // Adjust for horizontal scroll speed
        offset.y += initialScrollSpeedY / 60.0; // Adjust for vertical scroll speed
        [UIView animateWithDuration:1.0/60.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [self setContentOffset:offset];
                         } completion:^(BOOL finished) {
                             if (finished && (initialScrollSpeedX != 0 || initialScrollSpeedY != 0)) {
                                 [self startContinuousScroll];
                             }
                         }];
    }
}

@end

%hook UIScrollView

// Override the method that handles the end of dragging
- (void)scrollViewDidEndDragging:(BOOL)decelerate {
    if (!decelerate) {
        CGPoint velocity = [self.panGestureRecognizer velocityInView:self];
        initialScrollSpeedX = velocity.x;
        initialScrollSpeedY = velocity.y;
        [self startContinuousScroll];
    }
}

// Override the method that handles deceleration
- (void)scrollViewWillBeginDecelerating {
    [self setContentOffset:self.contentOffset animated:NO];
    [self startContinuousScroll];
}

// Override touches to handle interruption
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    initialScrollSpeedX = 0.0; // Stop horizontal scrolling on touch
    initialScrollSpeedY = 0.0; // Stop vertical scrolling on touch
    %orig;
}

// Override the method that handles the start of scrolling
- (void)scrollViewWillBeginDragging {
    initialScrollSpeedX = 0.0; // Reset horizontal scrolling speed
    initialScrollSpeedY = 0.0; // Reset vertical scrolling speed
}

%end
