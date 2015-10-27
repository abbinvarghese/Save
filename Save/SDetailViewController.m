//
//  SDetailViewController.m
//  Save
//
//  Created by Abbin on 20/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "SDetailViewController.h"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_4s ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@interface SDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property(nonatomic,strong)NSMutableString *amount;
@property (weak, nonatomic) IBOutlet AKPickerView *pickerViewCustom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountLabelUpper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currencyUpper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewUpper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewLower;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *pickerViewGesture;


@property (weak, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *two;
@property (weak, nonatomic) IBOutlet UIButton *three;
@property (weak, nonatomic) IBOutlet UIButton *four;
@property (weak, nonatomic) IBOutlet UIButton *five;
@property (weak, nonatomic) IBOutlet UIButton *six;
@property (weak, nonatomic) IBOutlet UIButton *seven;
@property (weak, nonatomic) IBOutlet UIButton *eight;
@property (weak, nonatomic) IBOutlet UIButton *nine;
@property (weak, nonatomic) IBOutlet UIButton *point;
@property (weak, nonatomic) IBOutlet UIButton *zero;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@property (weak, nonatomic) IBOutlet UITextView *notesView;
@property (weak, nonatomic) IBOutlet UIButton *dateView;
@property (weak, nonatomic) IBOutlet UIButton *imageButtonView;


@property (nonatomic,assign) CGPoint onePoint;
@property (nonatomic,assign) CGPoint twoPoint;
@property (nonatomic,assign) CGPoint threePoint;
@property (nonatomic,assign) CGPoint fourPoint;
@property (nonatomic,assign) CGPoint fivePoint;
@property (nonatomic,assign) CGPoint sixPoint;
@property (nonatomic,assign) CGPoint sevenPoint;
@property (nonatomic,assign) CGPoint eightPoint;
@property (nonatomic,assign) CGPoint ninePoint;
@property (nonatomic,assign) CGPoint zeroPoint;
@property (nonatomic,assign) CGPoint pointPoint;
@property (nonatomic,assign) CGPoint cancelPoint;
@property (nonatomic,assign) CGPoint pickerPoint;

@property (nonatomic,assign) int panInt;

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
        self.currencyUpper.constant = self.currencyUpper.constant-6;
        self.pickerViewUpper.constant = 20;
        self.pickerViewLower.constant = 20;
    }
    else if (IS_IPHONE_4s){
        self.amountLabel.font = [UIFont fontWithName:@"EuropeUnderground-Light" size:53];
        self.amountLabelUpper.constant = self.amountLabelUpper.constant-20;
        self.currencyUpper.constant = self.currencyUpper.constant-26;
        self.pickerViewUpper.constant = 10;
        self.pickerViewLower.constant = 5;
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
    [self.view endEditing:YES];
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
            self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
//            self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.7 blue:0.7 alpha:1];
            [UIView animateWithDuration:0.3 animations:^(void){
                self.innerView.frame = CGRectMake( translation.x, self.innerView.frame.origin.y, self.innerView.frame.size.width, self.innerView.frame.size.height);
                self.cancelLabel.center = CGPointMake(translation.x/2, self.cancelLabel.center.y);
            }];
        }
    }
}

- (IBAction)didPanRightOnInnerView:(UIScreenEdgePanGestureRecognizer *)sender {
    [self.view endEditing:YES];
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

- (IBAction)didSwipeDownNumPads:(UISwipeGestureRecognizer *)sender {
    [self animateIntoOptions];
}


-(void)animateIntoOptions{
    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.pointPoint = self.point.center;
        self.point.center = CGPointMake(self.point.center.x, [UIScreen mainScreen].bounds.size.height+self.point.bounds.size.height);
    }completion:^(BOOL finished){
        
    }];
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.sevenPoint = self.seven.center;
        self.seven.center = CGPointMake(self.seven.center.x, [UIScreen mainScreen].bounds.size.height+self.seven.bounds.size.height);
    }completion:^(BOOL finished){
        
    }];
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.fourPoint = self.four.center;
        self.four.center = CGPointMake(self.four.center.x, [UIScreen mainScreen].bounds.size.height+self.four.bounds.size.height);
    }completion:^(BOOL finished){
        
    }];
    [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.onePoint = self.one.center;
        self.one.center = CGPointMake(self.one.center.x, [UIScreen mainScreen].bounds.size.height+self.one.bounds.size.height);
    }completion:^(BOOL finished){
        
    }];
    
    

    [UIView animateWithDuration:0.1 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.zeroPoint = self.zero.center;
        self.zero.center = CGPointMake(self.zero.center.x, [UIScreen mainScreen].bounds.size.height+self.zero.bounds.size.height);
    }completion:^(BOOL finished){
        
    }];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.eightPoint = self.eight.center;
        self.eight.center = CGPointMake(self.eight.center.x, [UIScreen mainScreen].bounds.size.height+self.eight.bounds.size.height);
    }completion:^(BOOL finished){
        
    }];
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.fivePoint = self.five.center;
        self.five.center = CGPointMake(self.five.center.x, [UIScreen mainScreen].bounds.size.height+self.five.bounds.size.height);
    }completion:^(BOOL finished){
        
    }];
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.twoPoint = self.two.center;
        self.two.center = CGPointMake(self.two.center.x, [UIScreen mainScreen].bounds.size.height+self.two.bounds.size.height);
    }completion:^(BOOL finished){
        
    }];
    
    
    [UIView animateWithDuration:0.1 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.cancelPoint = self.cancel.center;
        self.cancel.center = CGPointMake(self.cancel.center.x, [UIScreen mainScreen].bounds.size.height+self.cancel.bounds.size.height);
    }completion:^(BOOL finished){
        
    }];
    [UIView animateWithDuration:0.2 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.ninePoint = self.nine.center;
        self.nine.center = CGPointMake(self.nine.center.x, [UIScreen mainScreen].bounds.size.height+self.nine.bounds.size.height);
    }completion:^(BOOL finished){
        
    }];
    [UIView animateWithDuration:0.3 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.sixPoint = self.six.center;
        self.six.center = CGPointMake(self.six.center.x, [UIScreen mainScreen].bounds.size.height+self.six.bounds.size.height);
    }completion:^(BOOL finished){
        
    }];
    [UIView animateWithDuration:0.4 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.threePoint = self.three.center;
        self.three.center = CGPointMake(self.three.center.x, [UIScreen mainScreen].bounds.size.height+self.three.bounds.size.height);
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.3 animations:^(void){
//            self.notesView.layer.cornerRadius = 5;
//            self.notesView.layer.masksToBounds = YES;
            self.notesView.layer.borderWidth = 1;
            self.notesView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
            self.notesView.alpha = 1;
//            self.dateView.layer.cornerRadius = 5;
//            self.dateView.layer.masksToBounds = YES;
            self.dateView.alpha = 1;
            self.dateView.layer.borderWidth = 1;
            self.dateView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
            self.imageButtonView.alpha = 1;
            
        }completion:^(BOOL finished){
            self.pickerViewGesture.enabled=YES;
        }];
    }];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.pickerPoint = self.pickerViewCustom.center;
        self.pickerViewCustom.center = CGPointMake(self.pickerViewCustom.center.x, self.pickerViewCustom.bounds.size.height/2+20);
    }completion:^(BOOL finished){
        
    }];
    

}

- (IBAction)didSwipeDownPickerView:(UISwipeGestureRecognizer *)sender {
    [self animateBack];
}


-(void)animateBack{
    
    [UIView animateWithDuration:0.3 animations:^(void){
        self.notesView.layer.borderWidth = 1;
        self.notesView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        self.notesView.alpha = 0;
        self.dateView.alpha = 0;
        self.dateView.layer.borderWidth = 1;
        self.dateView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        self.imageButtonView.alpha = 0;
    }completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.point.center = self.pointPoint;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.seven.center = self.sevenPoint;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.four.center = self.fourPoint;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.one.center = self.onePoint;
        }completion:^(BOOL finished){
            
        }];
        
        
        
        [UIView animateWithDuration:0.1 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.zero.center = self.zeroPoint;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.eight.center = self.eightPoint;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.five.center = self.fivePoint ;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.two.center = self.twoPoint;
        }completion:^(BOOL finished){
            
        }];
        
        
        [UIView animateWithDuration:0.1 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.cancel.center = self.cancelPoint ;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:0.2 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.nine.center = self.ninePoint;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:0.3 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.six.center = self.sixPoint;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:0.4 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.three.center = self.threePoint;
        }completion:^(BOOL finished){
            self.pickerViewGesture.enabled=NO;
        }];
        [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.pickerViewCustom.center = self.pickerPoint;
        }completion:^(BOOL finished){
            
        }];

        
    }];
}
- (IBAction)dateButtonClicked:(UIButton *)sender {
    if ([self.notesView isFirstResponder]) {
        [self.view endEditing:YES];
    }
    else{
        
    }
}
- (IBAction)imageButtonClicked:(UIButton *)sender {
    if ([self.notesView isFirstResponder]) {
        [self.view endEditing:YES];
    }
    else{
       
    }
}
- (IBAction)didPanDateButton:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        
    }
    else{
        CGPoint translation = [sender translationInView:self.dateView];
    }
}

@end
