//
//  ViewController.m
//  Save
//
//  Created by Abbin on 19/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

#import "ViewController.h"
#import "SDetailViewController.h"
#import "SLabel.h"
#import "IntroCollectionViewController.h"
#import "CoreDataHelper.h"
#import "NSDate+SDate.h"
#import "SEntriesTableViewController.h"
#import "AMPopTip.h"

@interface ViewController ()

{
    int screenWidth;
    int screenHeight;
    int middle;
    int middleOfMiddle;
}

@property (nonatomic, strong) BarChartView *chartView;
@property (nonatomic,strong) UILabel *monthLimitLab;

@property (weak, nonatomic) IBOutlet SLabel *incomeButton;
@property (weak, nonatomic) IBOutlet SLabel *expenseButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *expenceTap;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipe;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *downSwipe;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *upSwipe;

@property (nonatomic,assign) NSInteger monthlyLimit;
@property (nonatomic,assign) NSInteger monthlyLimit2;

@property (nonatomic,assign) CGPoint incomeCenter;
@property (nonatomic,assign) CGPoint expenceCenter;

@property (nonatomic, strong) AMPopTip *popTip;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popTip = [AMPopTip popTip];
    self.popTip.shouldDismissOnTap = YES;
    self.popTip.entranceAnimation = AMPopTipEntranceAnimationScale;
    self.popTip.actionAnimation = AMPopTipActionAnimationFloat;
    self.popTip.popoverColor = [UIColor blackColor];
    self.popTip.textColor = [UIColor whiteColor];
    self.popTip.dismissHandler = ^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstCameraLaunchKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };

    
    [self drawCustomeView];
    
    self.incomeCenter = self.incomeButton.center;
    self.expenceCenter = self.expenseButton.center;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    if (screenHeight % 2) {             //
        screenHeight++;                 //  Height adjustMents based on device screen size
    }                                   //
    
    middle = screenHeight/2;
    middleOfMiddle = middle/2;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
}

-(BOOL)isFirstCameraLaunch{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstCameraLaunchKey"]) {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self isFirstCameraLaunch]) {
            [self.popTip showText:@"Tap or swipe right or down" direction:AMPopTipDirectionUp
                         maxWidth:self.expenseButton.frame.size.width/1.5
                           inView:self.expenseButton
                        fromFrame:CGRectMake(self.expenseButton.frame.origin.x, self.expenseButton.frame.origin.y/3, self.expenseButton.frame.size.width, self.expenseButton.frame.size.height)];
    }
    
    [UIView animateWithDuration:0.3 animations:^(void){
        self.incomeButton.alpha = 1;
        self.expenseButton.alpha = 1;
    }];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.incomeButton.center = self.incomeCenter; //CGPointMake(self.view.center.x,self.incomeButton.center.y);
    }completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.expenseButton.center = self.expenceCenter; //CGPointMake(self.view.center.x,self.expenseButton.center.y);
    }completion:^(BOOL finished){
        
    }];
    
    
    // Launch the Introduction at first Launch(Checks for the "expence" key in UserDefaults which will be intiated in the finish of the introduction)
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"expense"]) {        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        IntroCollectionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"IntroCollectionViewController"];
        [self presentViewController:vc animated:NO completion:^(void){
            self.incomeButton.alpha = 0;
            self.expenseButton.alpha = 0;
        }];
    }

}

- (void) orientationChanged:(NSNotification *)note{
    if (self.view.superview != nil && [[NSUserDefaults standardUserDefaults] valueForKey:@"monthlyLimit"]) {
        UIDevice * device = note.object;
        switch(device.orientation)
        {
            case UIDeviceOrientationPortrait:
            {
                [UIView animateWithDuration:0.3 animations:^(void){
                    _chartView.alpha = 0;
                    self.incomeButton.alpha = 1;
                    self.expenseButton.alpha = 1;
                    self.monthLimitLab.alpha = 1;
                }completion:^(BOOL finished){
                    [_chartView removeFromSuperview];
                }];
            }
                break;
                
            case UIDeviceOrientationLandscapeLeft:{
                [UIView animateWithDuration:0.3 animations:^(void){
                    self.incomeButton.alpha = 0;
                    self.expenseButton.alpha = 0;
                    self.monthLimitLab.alpha = 0;
                }completion:^(BOOL finished){
                    [self drawChartWithOrintation:device.orientation];
                }];
            }
            case UIDeviceOrientationLandscapeRight:{
                [UIView animateWithDuration:0.3 animations:^(void){
                    self.incomeButton.alpha = 0;
                    self.expenseButton.alpha = 0;
                    self.monthLimitLab.alpha = 0;
                }completion:^(BOOL finished){
                    [self drawChartWithOrintation:device.orientation];
                }];
            }
                break;
                
            default:
                break;
        };
        
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark-
#pragma mark Custom View Initialization

- (void)drawCustomeView{
    [self.incomeButton drawRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2) withShadow:YES];
    [self.expenseButton drawRect:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2) withShadow:NO];
}

- (void)drawChartWithOrintation:(UIDeviceOrientation)orintation{
    if (!_chartView) {
        _chartView = [[BarChartView alloc]init];
        [_chartView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
    }
    
    if (orintation == UIDeviceOrientationLandscapeLeft) {
        _chartView.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
    }
    else{
        _chartView.transform = CGAffineTransformMakeRotation(DegreesToRadians(270));
    }
    
    if (![_chartView isDescendantOfView:self.view]) {
        _chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/1.1, [UIScreen mainScreen].bounds.size.height/1.1);
        _chartView.center = self.view.center;
        _chartView.delegate = self;
        
        _chartView.descriptionText = @"";
        _chartView.noDataTextDescription = @"You need to provide data for the chart.";
        
        _chartView.drawBarShadowEnabled = NO;
        _chartView.drawValueAboveBarEnabled = YES;
        
        _chartView.maxVisibleValueCount = 60;
        _chartView.pinchZoomEnabled = NO;
        _chartView.drawGridBackgroundEnabled = NO;
        
        ChartXAxis *xAxis = _chartView.xAxis;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.labelFont = [UIFont systemFontOfSize:10.f];
        xAxis.drawGridLinesEnabled = NO;
        xAxis.spaceBetweenLabels = 2.0;
        
        ChartYAxis *leftAxis = _chartView.leftAxis;
        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
        leftAxis.labelCount = 8;
        leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
        leftAxis.valueFormatter.maximumFractionDigits = 1;
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
        leftAxis.spaceTop = 0.15;
        
        ChartYAxis *rightAxis = _chartView.rightAxis;
        rightAxis.drawGridLinesEnabled = NO;
        rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
        rightAxis.labelCount = 8;
        rightAxis.valueFormatter = leftAxis.valueFormatter;
        rightAxis.spaceTop = 0.15;
        
        _chartView.legend.position = ChartLegendPositionBelowChartLeft;
        _chartView.legend.form = ChartLegendFormSquare;
        _chartView.legend.formSize = 9.0;
        _chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
        _chartView.legend.xEntrySpace = 4.0;
        
        
        _chartView.alpha = 0;
        
        [self setDataCount];
    }
    [self.view addSubview:_chartView];
    
    [UIView animateWithDuration:0.5 animations:^(void){
        _chartView.alpha = 1;
    }];

}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark-
#pragma mark OutLets

- (IBAction)incomeTapped:(UITapGestureRecognizer *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SDetailViewController"];
    vc.isIncome = YES;
    [self presentViewController:vc animated:NO completion:^(void){
        [self.chartView removeFromSuperview];
        self.chartView = nil;
        self.incomeButton.alpha = 0;
        self.expenseButton.alpha = 0;
    }];
}
- (IBAction)expenseTapped:(UITapGestureRecognizer *)sender {
    [self.popTip hide];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SDetailViewController"];
    vc.isIncome = NO;
    [self presentViewController:vc animated:NO completion:^(void){
        [self.chartView removeFromSuperview];
        self.chartView = nil;
        self.incomeButton.alpha = 0;
        self.expenseButton.alpha = 0;
    }];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark-
#pragma mark Gesture Recognizers

- (void)didpanMonthlyLimit:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.monthlyLimit = self.monthlyLimit2;
    }
    else{
        CGPoint tran = [recognizer translationInView:self.view];
        NSString *string = [NSString stringWithFormat:@"%i",(int)tran.y];
        if (string.length>1) {
            string = [string substringToIndex:[string length]-1];
        }
        self.monthlyLimit2 = self.monthlyLimit + [string intValue]*100;
        self.monthLimitLab.text = [[CoreDataHelper sharedCLCoreDataHelper] currencyFormString:[NSString stringWithFormat:@"%ld",(long)self.monthlyLimit2]];
        
    }

}

- (IBAction)expenseSwiped:(UISwipeGestureRecognizer *)sender {
    [self.popTip hide];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.expenseButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width+self.expenseButton.frame.size.width,self.expenseButton.center.y);
    }completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.incomeButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width+self.incomeButton.frame.size.width,self.incomeButton.center.y);
    }completion:^(BOOL finished){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SEntriesTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SEntriesTableViewController"];
        [self presentViewController:vc animated:NO completion:^(void){
            
        }];
        
    }];
}

- (IBAction)expenceSwipedDown:(UISwipeGestureRecognizer *)sender {
    [self.popTip hide];
    if (!self.monthLimitLab) {
        self.monthLimitLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.incomeButton.frame.size.height, [UIScreen mainScreen].bounds.size.width, 50)];
        self.monthLimitLab.font = [UIFont fontWithName:@"Adequate-ExtraLight" size:20];
        self.monthlyLimit = [[[NSUserDefaults standardUserDefaults] valueForKey:@"monthlyLimit"] integerValue];
        self.monthLimitLab.text = [[CoreDataHelper sharedCLCoreDataHelper] currencyFormString:[NSString stringWithFormat:@"%ld",(long)self.monthlyLimit]];
        self.monthLimitLab.userInteractionEnabled = YES;
        [self.monthLimitLab setTextAlignment:NSTextAlignmentCenter];
        
        UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(didpanMonthlyLimit:)];
        
        [self.monthLimitLab addGestureRecognizer:pgr];
        
    }
    [self.view insertSubview:self.monthLimitLab atIndex:0];
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    self.expenceTap.enabled = NO;
    self.incomeButton.userInteractionEnabled = NO;
    self.rightSwipe.enabled = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.expenseButton.center = CGPointMake(self.expenseButton.center.x, self.expenseButton.center.y+50);
    }completion:^(BOOL finished){
        self.upSwipe.enabled = YES;
        self.downSwipe.enabled = NO;
        self.expenseButton.shouldTouch = NO;
    }];
}

- (IBAction)expenceSwipedUp:(UISwipeGestureRecognizer *)sender {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.expenseButton.center = self.expenceCenter;
    }completion:^(BOOL finished){
        self.view.backgroundColor = [UIColor whiteColor];
        self.expenceTap.enabled = YES;
        self.incomeButton.userInteractionEnabled = YES;
        self.rightSwipe.enabled = YES;
        self.upSwipe.enabled = NO;
        self.downSwipe.enabled = YES;
        self.expenseButton.shouldTouch = YES;
        [self.monthLimitLab removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",(long)self.monthlyLimit] forKey:@"monthlyLimit"];
    }];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 
#pragma mark Utility Methods

- (void)setDataCount{
    NSMutableArray *xVals = [[CoreDataHelper sharedCLCoreDataHelper]collectFinalBalanceWithMonthDate:[NSString stringWithFormat:@"%ld%ld",(long)[NSDate date].year,(long)[NSDate date].month]];
    
    NSMutableArray *yVals = [[CoreDataHelper sharedCLCoreDataHelper]collectFinalBalanceAmountWithMonthDate:[[NSString stringWithFormat:@"%ld%ld",(long)[NSDate date].year,(long)[NSDate date].month] doubleValue]];
    
    if (yVals.count>0 && xVals.count>0) {
        BarChartDataEntry *last = [yVals objectAtIndex:yVals.count-1];
        NSString *lastStr = [NSString stringWithFormat:@"%f",last.value];
        BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:[[CoreDataHelper sharedCLCoreDataHelper] currencyFormString:lastStr]];
        set1.barSpace = 0.35;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:5.f]];
        
        _chartView.data = data;
    }
}


@end
