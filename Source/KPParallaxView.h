//
//  WPParallaxView.h
//  WeHeartPics
//
//  Created by Katerina Petrova on 10/16/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface KPParallaxView : UIView
@property (nonatomic, assign) CGFloat deltaX;
@property (nonatomic, assign) CGFloat deltaY;

- (void)startMoving;
- (void)stopMoving;
@end
