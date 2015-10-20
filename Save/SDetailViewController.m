//
//  SDetailViewController.m
//  Save
//
//  Created by Abbin on 20/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "SDetailViewController.h"

@interface SDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *innerView;

@end

@implementation SDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPanInnerView:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.innerView];
    
//    sender.view.center = CGPointMake(sender.view.center.x + translation.x,
//                                         sender.view.center.y + translation.y);
    
//    NSLog(@"%f",sender.view.center.y);
    NSLog(@"%f",translation.y);
//    NSLog(@"%f",translation.x);
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        
//        // Check here for the position of the view when the user stops touching the screen
//        
//        // Set "CGFloat finalX" and "CGFloat finalY", depending on the last position of the touch
//        
//        // Use this to animate the position of your view to where you want
//        [UIView animateWithDuration: 0.5
//                              delay: 0
//                            options: UIViewAnimationOptionCurveEaseOut
//                         animations:^{
//                             CGPoint finalPoint = CGPointMake(finalX, finalY);
//                             sender.view.center = finalPoint; }
//                         completion:nil];
//    }
//    
//    
//    [recognizer setTranslation:CGPointMake(0, 0) inView:_myScroll];
}


@end
