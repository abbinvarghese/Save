//
//  ViewController.m
//  Save
//
//  Created by Abbin on 19/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "ViewController.h"
#import "SDetailViewController.h"

#define kraiseAnimation @"raise"
#define klowerAnimation @"lower"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SView *upperView;
@property (weak, nonatomic) IBOutlet SView *lowerView;
@property (weak, nonatomic) IBOutlet UIButton *expenseButton;
@property (weak, nonatomic) IBOutlet UIButton *incomeButton;

@property(nonatomic,strong)POPBasicAnimation *raiseAnimation;
@property(nonatomic,strong)POPBasicAnimation *lowerAnimation;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.upperView.viewTag = 0;
    self.lowerView.viewTag = 1;
    self.raiseAnimation = [POPBasicAnimation animation];
    self.raiseAnimation.name = kraiseAnimation;
    self.raiseAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenWidth = screenRect.size.width;
    int screenHeight = screenRect.size.height;
    if (screenHeight % 2) {
        screenHeight++;
    }
    int middle = screenHeight/2;
    int middleOfMiddle = middle/2;
    
    self.raiseAnimation.toValue=[NSValue valueWithCGPoint:CGPointMake(screenWidth/2,middleOfMiddle)];
    self.raiseAnimation.delegate=self;
    
    self.lowerAnimation = [POPBasicAnimation animation];
    self.lowerAnimation.name = klowerAnimation;
    self.lowerAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    self.lowerAnimation.toValue=[NSValue valueWithCGPoint:CGPointMake(screenWidth/2,middle + middleOfMiddle+50)];
    self.lowerAnimation.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [UIView animateWithDuration:0.3 animations:^(void){
        self.upperView.alpha = 1;
        self.lowerView.alpha = 1;
    }];
}

- (IBAction)didSwipeDownOnUpperView:(UISwipeGestureRecognizer *)sender {
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.upperView pop_addAnimation:self.lowerAnimation forKey:klowerAnimation];
    [self.upperView touchesBegan:nil withEvent:nil];
    self.upperView.shouldTouch = NO;
}

- (IBAction)didSwipeUpOnUpperView:(UISwipeGestureRecognizer *)sender {
    [self.upperView pop_addAnimation:self.raiseAnimation forKey:kraiseAnimation];
    self.upperView.shouldTouch = YES;
    [self.upperView touchesEnded:nil withEvent:nil];
}

- (IBAction)incomeTapped:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SDetailViewController"];
    vc.isIncome = YES;
    [self presentViewController:vc animated:NO completion:^(void){
            self.upperView.alpha = 0;
            self.lowerView.alpha = 0;
    }];
//    [UIView animateWithDuration:0.2 animations:^(void){
//        self.upperView.alpha = 0;
//        self.lowerView.alpha = 0;
//    }completion:^(BOOL finished){
//        self.upperView.hidden=YES;
//        self.lowerView.hidden=YES;
//    }];
}

- (IBAction)expenceTapped:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SDetailViewController"];
    vc.isIncome = NO;
    [self presentViewController:vc animated:NO completion:^(void){
        self.upperView.alpha = 0;
        self.lowerView.alpha = 0;
    }];
//    [UIView animateWithDuration:0.2 animations:^(void){
//        self.upperView.alpha = 0;
//        self.lowerView.alpha = 0;
//    }completion:^(BOOL finished){
//        self.upperView.hidden=YES;
//        self.lowerView.hidden=YES;
//    }];
}

- (void)pop_animationDidStart:(POPAnimation *)anim{
    if ([anim.name isEqualToString:klowerAnimation]) {
        self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        self.incomeButton.enabled = NO;
    }
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    if ([anim.name isEqualToString:kraiseAnimation]) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.incomeButton.enabled = YES;
    }
}

@end
