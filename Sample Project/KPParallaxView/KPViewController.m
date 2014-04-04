//
//  KPViewController.m
//  KPParallaxView
//
//  Created by Katerina Petrova on 04/04/14.
//
//

#import "KPViewController.h"
#import "KPParallaxView.h"

@interface KPViewController ()

@end

@implementation KPViewController {
    IBOutlet KPParallaxView *_parallaxView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _parallaxView.deltaX = 150.0f;
    _parallaxView.deltaY = 30.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_parallaxView startMoving];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_parallaxView stopMoving];
}

//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//}

@end
