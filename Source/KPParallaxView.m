//
//  WPParallaxView.m
//  WeHeartPics
//
//  Created by Katerina Petrova on 10/16/13.
//
//

#import "KPParallaxView.h"
#import "AccelerometerFilter.h"

#define UPDATE_INTERVAL 1.0f/60
#define DEFAULT_DELTA 30.0

@implementation KPParallaxView {
    CMMotionManager *_motionManager;
    AccelerometerFilter *_filter;
    CGPoint _translation;
}
@synthesize deltaX = _deltaX, deltaY = _deltaY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = UPDATE_INTERVAL;
    
    _filter = [[LowpassFilter alloc] initWithSampleRate:60 cutoffFrequency:5.0];
    _filter.adaptive = NO;
    
    _deltaX = _deltaY = DEFAULT_DELTA;
}

- (void)startMoving
{
    if (![_motionManager isDeviceMotionAvailable])
        return;
    
    __block BOOL isReferenceSet = NO;
    __block CGPoint reference = CGPointZero;
    
    [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if (!isReferenceSet) {
            reference.x = motion.gravity.x;
            reference.y = motion.gravity.y;
            isReferenceSet = YES;
        }
        
        [_filter addAccelerationX:motion.gravity.x y:motion.gravity.y z:motion.gravity.z];
        
        [UIView beginAnimations:@"translate" context:nil];
        self.transform = CGAffineTransformMakeTranslation(_translation.x, _translation.y);
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            CGFloat factor = orientation == UIInterfaceOrientationPortraitUpsideDown ? -1 : 1;
            _translation.x = -_deltaX * factor * (atan(8 * (reference.x - _filter.x)) / (M_PI / 2));
            _translation.y = _deltaY * factor * (atan(8 * (reference.y - _filter.y)) / (M_PI / 2));
        } else {
            CGFloat factor = orientation == UIDeviceOrientationLandscapeLeft ? -1 : 1;
            _translation.x = -_deltaX * factor * (atan(8 * (reference.y - _filter.y)) / (M_PI / 2));
            _translation.y = -_deltaY * factor * (atan(8 * (reference.x - _filter.x)) / (M_PI / 2));
        }
        [UIView commitAnimations];
    }];
}

- (void)stopMoving
{
    if (![_motionManager isDeviceMotionAvailable])
        return;
    
    [_motionManager stopDeviceMotionUpdates];
}

- (void)dealloc
{
    _motionManager = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
