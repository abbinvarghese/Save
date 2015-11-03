//
//  ViewController.m
//  Save
//
//  Created by Abbin on 19/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "ViewController.h"
#import "SDetailViewController.h"
#import "SLabel.h"

#define kraiseAnimation @"raise"
#define klowerAnimation @"lower"
#define kLowerShadowAnimation @"raiseShadow"
#define kRaiseShadowAnimation @"lowerShadow"

@interface ViewController ()

@property(nonatomic,strong)POPBasicAnimation *raiseAnimation;
@property(nonatomic,strong)POPBasicAnimation *lowerAnimation;
@property(nonatomic,strong)POPBasicAnimation *raiseShadowAnimation;
@property(nonatomic,strong)POPBasicAnimation *lowerShadowAnimation;
@property (weak, nonatomic) IBOutlet SLabel *incomeButton;
@property (weak, nonatomic) IBOutlet SLabel *expenseButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *incomeTap;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawCustomeView];
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
    
    
    self.lowerShadowAnimation = [POPBasicAnimation animation];
    self.lowerShadowAnimation.name = kLowerShadowAnimation;
    self.lowerShadowAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerShadowOpacity];
    self.lowerShadowAnimation.toValue=@(1);
    self.lowerShadowAnimation.delegate=self;
    
    self.raiseShadowAnimation = [POPBasicAnimation animation];
    self.raiseShadowAnimation.name = kRaiseShadowAnimation;
    self.raiseShadowAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerShadowOpacity];
    self.raiseShadowAnimation.toValue=@(0);
    self.raiseShadowAnimation.delegate=self;
}

-(void)drawCustomeView{
    [self.incomeButton drawRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2) withShadow:YES];
    [self.expenseButton drawRect:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2) withShadow:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^(void){
        self.incomeButton.alpha = 1;
        self.expenseButton.alpha = 1;
    }];
}

- (IBAction)didSwipeDownOnUpperView:(UISwipeGestureRecognizer *)sender {
    [self.incomeButton pop_addAnimation:self.lowerAnimation forKey:klowerAnimation];
    [self.incomeButton.layer pop_addAnimation:self.lowerShadowAnimation forKey:kLowerShadowAnimation];
}

- (IBAction)didSwipeUpOnUpperView:(UISwipeGestureRecognizer *)sender {
    [self.incomeButton pop_addAnimation:self.raiseAnimation forKey:kraiseAnimation];
    [self.incomeButton.layer pop_addAnimation:self.raiseShadowAnimation forKey:kRaiseShadowAnimation];
}

- (IBAction)incomeTapped:(UITapGestureRecognizer *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SDetailViewController"];
    vc.isIncome = YES;
    [self presentViewController:vc animated:NO completion:^(void){
        self.incomeButton.alpha = 0;
        self.expenseButton.alpha = 0;
    }];
}
- (IBAction)expenseTapped:(UITapGestureRecognizer *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SDetailViewController"];
    vc.isIncome = NO;
    [self presentViewController:vc animated:NO completion:^(void){
        self.incomeButton.alpha = 0;
        self.expenseButton.alpha = 0;
    }];
}


- (void)pop_animationDidStart:(POPAnimation *)anim{
    if ([anim.name isEqualToString:klowerAnimation]) {
        self.incomeButton.shouldTouch = NO;
        self.incomeTap.enabled = NO;
    }
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    if ([anim.name isEqualToString:kraiseAnimation]) {
        self.incomeButton.shouldTouch = YES;
        self.incomeTap.enabled = YES;
    }
}

@end
