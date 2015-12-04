//
//  IntroCollectionViewCellTwo.m
//  Save
//
//  Created by Abbin on 20/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_4s ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

#import "IntroCollectionViewCellTwo.h"
#import "CoreDataHelper.h"
#import "NSDate+SDate.h"


@implementation IntroCollectionViewCellTwo

int buttonHeight;
int buttonWidth;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"IntroCollectionViewCellTwo" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        buttonWidth = [UIScreen mainScreen].bounds.size.width/3;
        buttonHeight = [UIScreen mainScreen].bounds.size.height/2/4;
        self.amount = [[NSMutableString alloc]init];
        [self drawThird];
        if (self.amount.length>0) {
            self.cellNextButton.enabled = YES;
        }
        else{
            self.cellNextButton.enabled = NO;
        }
    }
    
    return self;
}

-(void)drawThird{
    
    IntroButton *point = [[IntroButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-buttonHeight-70, buttonWidth, buttonHeight)];
    [point setTitle:@"." forState:UIControlStateNormal];
    [point addTarget:self action:@selector(pointTapped:) forControlEvents:UIControlEventTouchUpInside];
    IntroButton *zero = [[IntroButton alloc]initWithFrame:CGRectMake(buttonWidth, [UIScreen mainScreen].bounds.size.height-buttonHeight-70, buttonWidth, buttonHeight)];
    [zero setTitle:@"0" forState:UIControlStateNormal];
    [zero addTarget:self action:@selector(zeroTapped:) forControlEvents:UIControlEventTouchUpInside];
    IntroButton *cancel = [[IntroButton alloc]initWithFrame:CGRectMake(buttonWidth*2, [UIScreen mainScreen].bounds.size.height-buttonHeight-70, buttonWidth, buttonHeight)];
    [cancel setTitle:@"C" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(backspaceTapped:) forControlEvents:UIControlEventTouchUpInside];
    IntroButton *seven = [[IntroButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-buttonHeight*2-70, buttonWidth, buttonHeight)];
    [seven setTitle:@"7" forState:UIControlStateNormal];
    [seven addTarget:self action:@selector(sevenTapped:) forControlEvents:UIControlEventTouchUpInside];
    IntroButton *eight = [[IntroButton alloc]initWithFrame:CGRectMake(buttonWidth, [UIScreen mainScreen].bounds.size.height-buttonHeight*2-70, buttonWidth, buttonHeight)];
    [eight setTitle:@"8" forState:UIControlStateNormal];
    [eight addTarget:self action:@selector(eightTapped:) forControlEvents:UIControlEventTouchUpInside];
    IntroButton *nine = [[IntroButton alloc]initWithFrame:CGRectMake(buttonWidth*2, [UIScreen mainScreen].bounds.size.height-buttonHeight*2-70, buttonWidth, buttonHeight)];
    [nine setTitle:@"9" forState:UIControlStateNormal];
    [nine addTarget:self action:@selector(nineTapped:) forControlEvents:UIControlEventTouchUpInside];
    IntroButton *four = [[IntroButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-buttonHeight*3-70, buttonWidth, buttonHeight)];
    [four setTitle:@"4" forState:UIControlStateNormal];
    [four addTarget:self action:@selector(fourTapped:) forControlEvents:UIControlEventTouchUpInside];
    IntroButton *five = [[IntroButton alloc]initWithFrame:CGRectMake(buttonWidth, [UIScreen mainScreen].bounds.size.height-buttonHeight*3-70, buttonWidth, buttonHeight)];
    [five setTitle:@"5" forState:UIControlStateNormal];
    [five addTarget:self action:@selector(fiveTapped:) forControlEvents:UIControlEventTouchUpInside];
    IntroButton *six = [[IntroButton alloc]initWithFrame:CGRectMake(buttonWidth*2, [UIScreen mainScreen].bounds.size.height-buttonHeight*3-70, buttonWidth, buttonHeight)];
    [six setTitle:@"6" forState:UIControlStateNormal];
    [six addTarget:self action:@selector(sixTapped:) forControlEvents:UIControlEventTouchUpInside];
    IntroButton *one = [[IntroButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-buttonHeight*4-70, buttonWidth, buttonHeight)];
    [one setTitle:@"1" forState:UIControlStateNormal];
    [one addTarget:self action:@selector(oneTapped:) forControlEvents:UIControlEventTouchUpInside];
    IntroButton *two = [[IntroButton alloc]initWithFrame:CGRectMake(buttonWidth, [UIScreen mainScreen].bounds.size.height-buttonHeight*4-70, buttonWidth, buttonHeight)];
    [two setTitle:@"2" forState:UIControlStateNormal];
    [two addTarget:self action:@selector(twoTapped:) forControlEvents:UIControlEventTouchUpInside];
    IntroButton *three = [[IntroButton alloc]initWithFrame:CGRectMake(buttonWidth*2, [UIScreen mainScreen].bounds.size.height-buttonHeight*4-70, buttonWidth, buttonHeight)];
    [three setTitle:@"3" forState:UIControlStateNormal];
    [three addTarget:self action:@selector(threeTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cellNextButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-70, [UIScreen mainScreen].bounds.size.width, 70);
    
    [self addSubview:point];
    [self addSubview:zero];
    [self addSubview:cancel];
    [self addSubview:seven];
    [self addSubview:eight];
    [self addSubview:nine];
    [self addSubview:four];
    [self addSubview:five];
    [self addSubview:six];
    [self addSubview:one];
    [self addSubview:two];
    [self addSubview:three];
    
    self.amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width, 50)];
    self.amountLabel.text = @"enter a monthly limit on your expence";
    self.amountLabel.alpha = 0;
    if (IS_IPHONE_4s) {
        [self.amountLabel setFont:[UIFont fontWithName:@"Adequate-ExtraLight" size:10]];
    }
    else if (IS_IPHONE_5){
        [self.amountLabel setFont:[UIFont fontWithName:@"Adequate-ExtraLight" size:12]];
    }
    else{
        [self.amountLabel setFont:[UIFont fontWithName:@"Adequate-ExtraLight" size:14]];
    }
    [self.amountLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.amountLabel];
    
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        point.alpha = 1;
        zero.alpha = 1;
        cancel.alpha = 1;
        seven.alpha = 1;
        eight.alpha = 1;
        nine.alpha = 1;
        four.alpha = 1;
        five.alpha = 1;
        six.alpha = 1;
        one.alpha = 1;
        two.alpha = 1;
        self.amountLabel.alpha = 1;
        three.alpha = 1;
        self.cellNextButton.alpha = 1;
    }completion:^(BOOL finished){
        [self animateLabel];
    }];
}

- (void)oneTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"1"];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}
- (void)twoTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"2"];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}
- (void)threeTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"3"];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}
- (void)fourTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"4"];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}
- (void)fiveTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"5"];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}
- (void)sixTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"6"];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}
- (void)sevenTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"7"];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}
- (void)eightTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"8"];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}
- (void)nineTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"9"];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}
- (void)pointTapped:(UIButton *)sender {
    if (self.amount.length<9) {
        [self.amount appendString:@"."];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}
- (void)zeroTapped:(UIButton *)sender {
    if (self.amount.length<8) {
        [self.amount appendString:@"0"];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}
- (void)backspaceTapped:(UIButton *)sender {
    if (self.amount.length>0) {
        [self.amount setString:[self.amount substringToIndex:[self.amount length]-1]];
        self.amountLabel.text = [self currencyFormString:self.amount];
    }
    if (self.amount.length>0) {
        self.cellNextButton.enabled = YES;
    }
    else{
        self.cellNextButton.enabled = NO;
    }
}

-(NSString*)currencyFormString:(NSString*)string{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setLocale:[NSLocale currentLocale]];
    [currencyFormatter setMaximumFractionDigits:2];
    [currencyFormatter setMinimumFractionDigits:2];
    [currencyFormatter setAlwaysShowsDecimalSeparator:YES];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSNumber *someAmount = [NSNumber numberWithFloat:[string floatValue]];
    return [currencyFormatter stringFromNumber:someAmount];
}


-(void)animateLabel{
    [UIView animateWithDuration:5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.amountLabel.center = CGPointMake(self.amountLabel.center.x, self.amountLabel.center.y-50);
        self.amountLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        self.amountLabel.alpha = 0.5;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            self.amountLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            self.amountLabel.center = CGPointMake(self.amountLabel.center.x, self.amountLabel.center.y+50);
            self.amountLabel.alpha = 1;
        }completion:^(BOOL finished){
            
        }];
    }];
}

- (IBAction)nextTaped:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(introCelldidtapNextTwo:)]) {
        [self.delegate introCelldidtapNextTwo:self];
        [self performSelectorInBackground:@selector(saveInBackThread) withObject:nil];
    }
    
}

-(void)saveInBackThread{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *expense = [[NSArray alloc]initWithObjects:@"Travel",@"Food & Drinks",@"Bills",@"Entertainment",@"Shopping",@"Healthcare",@"Clothing",@"Education",@"Rent",@"Gifts", nil];
    NSArray *income = [[NSArray alloc]initWithObjects:@"Salary", @"Business",@"Loans",@"Gifts", @"Shares", nil];
    [defaults setObject:expense forKey:@"expense"];
    [defaults setObject:income forKey:@"income"];
    [defaults setObject:[NSDate date] forKey:@"monthlyLimitDay"];
    [defaults setObject:self.amount forKey:@"monthlyLimit"];
    [defaults synchronize];
}

@end
