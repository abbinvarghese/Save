//
//  SDetailViewController.m
//  Save
//
//  Created by Abbin on 20/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "SDetailViewController.h"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface SDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountLabelHeight;

@property(nonatomic,strong)NSMutableString *amount;
@property (weak, nonatomic) IBOutlet AKPickerView *pickerViewCustom;

@end

@implementation SDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerViewCustom.delegate = self;
    self.pickerViewCustom.dataSource = self;
    self.pickerViewCustom.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pickerViewCustom.font = [UIFont fontWithName:@"Adequate-ExtraLight" size:20];
    self.pickerViewCustom.highlightedFont = [UIFont fontWithName:@"Adequate-ExtraLight" size:21];
    self.pickerViewCustom.interitemSpacing = 20.0;
    self.pickerViewCustom.fisheyeFactor = 0.001;
    self.pickerViewCustom.pickerViewStyle = AKPickerViewStyle3D;
    self.pickerViewCustom.maskDisabled = false;
    if (self.isIncome) {
        self.pickerViewCustom.backgroundColor = [UIColor colorWithRed:0.9 green:1 blue:0.9 alpha:1];
    }
    else{
        self.pickerViewCustom.backgroundColor = [UIColor colorWithRed:1 green:0.9 blue:0.9 alpha:1];
    }

    self.amount = [NSMutableString string];
    if (IS_IPHONE_5) {
        self.amountLabel.font = [UIFont fontWithName:@"EuropeUnderground-Light" size:53];
        self.amountLabelHeight.constant = self.amountLabelHeight.constant+17;
    }
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^(void){
        self.innerView.alpha = 1;
    }completion:^(BOOL finished){
        self.saveLabel.alpha = 1;
        self.cancelLabel.alpha = 1;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPanOnInnerView:(UIScreenEdgePanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.innerView];
    
    if ((int)translation.x >[UIScreen mainScreen].bounds.size.width/2) {
        sender.enabled = NO;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.innerView.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width, self.innerView.frame.origin.y, self.innerView.frame.size.width, self.innerView.frame.size.height);
            self.cancelLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.cancelLabel.center.y);
            self.saveLabel.hidden = YES;
        }completion:^(BOOL finished){
            self.cancelLabel.textColor = [UIColor redColor];
            [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(dismissView)
                                           userInfo:nil
                                            repeats:NO];
        }];
    }
    else{
        if (sender.state == UIGestureRecognizerStateEnded) {
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                self.innerView.frame = CGRectMake( 0, self.innerView.frame.origin.y, self.innerView.frame.size.width, self.innerView.frame.size.height);
                self.cancelLabel.center = CGPointMake(0, self.cancelLabel.center.y);
            }completion:^(BOOL finished){
                self.view.backgroundColor = [UIColor whiteColor];
            }];
        }
        else{
            //self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.7 blue:0.7 alpha:1];
            [UIView animateWithDuration:0.3 animations:^(void){
                self.innerView.frame = CGRectMake( translation.x, self.innerView.frame.origin.y, self.innerView.frame.size.width, self.innerView.frame.size.height);
                self.cancelLabel.center = CGPointMake(translation.x/2, self.cancelLabel.center.y);
            }];
        }
    }
}

- (IBAction)didPanRightOnInnerView:(UIScreenEdgePanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.innerView];
    if ((int)translation.x < -[UIScreen mainScreen].bounds.size.width/2) {
        if ([self.amount intValue]>0) {
            sender.enabled = NO;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                self.innerView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width-20, self.innerView.frame.origin.y, self.innerView.frame.size.width, self.innerView.frame.size.height);
                self.saveLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.cancelLabel.center.y);
                self.cancelLabel.hidden = YES;
            }completion:^(BOOL finished){
                self.saveLabel.textColor = [UIColor blueColor];
                [NSTimer scheduledTimerWithTimeInterval:0.5
                                                 target:self
                                               selector:@selector(dismissView)
                                               userInfo:nil
                                                repeats:NO];
            }];
        }
        else{
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                self.innerView.frame = CGRectMake( 0, self.innerView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                self.saveLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width, self.cancelLabel.center.y);
            }completion:^(BOOL finished){
                self.view.backgroundColor = [UIColor whiteColor];
            }];
        }
    }
    else{
        if (sender.state == UIGestureRecognizerStateEnded) {
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                self.innerView.frame = CGRectMake( 0, self.innerView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                self.saveLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width, self.cancelLabel.center.y);
            }completion:^(BOOL finished){
                self.view.backgroundColor = [UIColor whiteColor];
            }];
        }
        else{
            //self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:1 alpha:1];
            if ([self.amount intValue]>0) {
                self.saveLabel.text = @"save";
            }
            else{
                self.saveLabel.text = @"huh?";
            }
            [UIView animateWithDuration:0.3 animations:^(void){
                self.innerView.frame = CGRectMake( translation.x, self.innerView.frame.origin.y, self.innerView.frame.size.width, self.innerView.frame.size.height);
                int left = ([UIScreen mainScreen].bounds.size.width);
                int center = left+(translation.x/2);
                self.saveLabel.center = CGPointMake(center, self.cancelLabel.center.y);
            }];
        }

    }
}

-(void)dismissView{
    
    [UIView animateWithDuration:0.3 animations:^(void){
        self.view.backgroundColor = [UIColor whiteColor];
        self.saveLabel.alpha = 0;
        self.cancelLabel.alpha = 0;
    }completion:^(BOOL finished){
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (IBAction)oneTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"1"];
        self.amountLabel.text = self.amount;
        sender.titleLabel.textColor = [UIColor yellowColor];
    }
}
- (IBAction)twoTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"2"];
        self.amountLabel.text = self.amount;
    }
}
- (IBAction)threeTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"3"];
        self.amountLabel.text = self.amount;
    }
}
- (IBAction)fourTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"4"];
        self.amountLabel.text = self.amount;
    }
}
- (IBAction)fiveTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"5"];
        self.amountLabel.text = self.amount;
    }
}
- (IBAction)sixTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"6"];
        self.amountLabel.text = self.amount;
    }
}
- (IBAction)sevenTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"7"];
        self.amountLabel.text = self.amount;
    }
}
- (IBAction)eightTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"8"];
        self.amountLabel.text = self.amount;
    }
}
- (IBAction)nineTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"9"];
        self.amountLabel.text = self.amount;
    }
}
- (IBAction)pointTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"."];
        self.amountLabel.text = self.amount;
    }
}
- (IBAction)zeroTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"0"];
        self.amountLabel.text = self.amount;
    }
}
- (IBAction)backspaceTapped:(UIButton *)sender {
    if (self.amount.length>0) {
        [self.amount setString:[self.amount substringToIndex:[self.amount length]-1]];
        self.amountLabel.text = self.amount;
    }
}


- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return 15;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [NSString stringWithFormat:@"%ld",(long)item];
}

#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    
}


@end
