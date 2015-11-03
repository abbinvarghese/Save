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

@interface ViewController ()

{
    int screenWidth;
    int screenHeight;
    int middle;
    int middleOfMiddle;
}

@property (weak, nonatomic) IBOutlet SLabel *incomeButton;
@property (weak, nonatomic) IBOutlet SLabel *expenseButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *incomeTap;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawCustomeView];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    if (screenHeight % 2) {
        screenHeight++;
    }
    middle = screenHeight/2;
    middleOfMiddle = middle/2;
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
    
    self.incomeButton.shouldTouch = NO;
    self.incomeTap.enabled = NO;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.incomeButton.center = CGPointMake(screenWidth/2,middle + middleOfMiddle+50);
        self.incomeButton.layer.shadowOpacity = 1;
    }completion:^(BOOL finished){
        
    }];
}

- (IBAction)didSwipeUpOnUpperView:(UISwipeGestureRecognizer *)sender {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.incomeButton.center = CGPointMake(screenWidth/2,middleOfMiddle);
        self.incomeButton.layer.shadowOpacity = 0;
    }completion:^(BOOL finished){
        self.incomeButton.shouldTouch = YES;
        self.incomeTap.enabled = YES;
    }];
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

@end
