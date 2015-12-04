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

@interface ViewController ()

{
    int screenWidth;
    int screenHeight;
    int middle;
    int middleOfMiddle;
}

@property (nonatomic, strong) BarChartView *chartView;
@property (weak, nonatomic) IBOutlet SLabel *incomeButton;
@property (weak, nonatomic) IBOutlet SLabel *expenseButton;

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
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
        {
            [self setNeedsStatusBarAppearanceUpdate];
            [UIView animateWithDuration:0.3 animations:^(void){
                _chartView.alpha = 0;
                self.incomeButton.alpha = 1;
                self.expenseButton.alpha = 1;
            }completion:^(BOOL finished){
                [_chartView removeFromSuperview];
            }];
        }
            break;
            
        case UIDeviceOrientationLandscapeLeft:{
            [self setNeedsStatusBarAppearanceUpdate];
            [UIView animateWithDuration:0.3 animations:^(void){
                self.incomeButton.alpha = 0;
                self.expenseButton.alpha = 0;
            }completion:^(BOOL finished){
                [self drawChartWithOrintation:device.orientation];
            }];
        }
        case UIDeviceOrientationLandscapeRight:{
            [self setNeedsStatusBarAppearanceUpdate];
            [UIView animateWithDuration:0.3 animations:^(void){
                self.incomeButton.alpha = 0;
                self.expenseButton.alpha = 0;
            }completion:^(BOOL finished){
                [self drawChartWithOrintation:device.orientation];
            }];
        }
            break;
            
        default:
        {
            [self setNeedsStatusBarAppearanceUpdate];
        }
            break;
    };
}

- (BOOL)prefersStatusBarHidden {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        return YES;
    }
    else{
        return NO;
    }
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
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.incomeButton.center = CGPointMake(self.view.center.x,self.incomeButton.center.y);
    }completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.expenseButton.center = CGPointMake(self.view.center.x,self.expenseButton.center.y);
    }completion:^(BOOL finished){
        
    }];
    
    // CREATES THE TYPE ARRAYS IN USER DEFAULTS AND LAUNCHS THE INTRO SCREEN IF ITS THE FIRST TIME LAUNCH
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"expense"]) {        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        IntroCollectionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"IntroCollectionViewController"];
        [self presentViewController:vc animated:NO completion:^(void){
            self.incomeButton.alpha = 0;
            self.expenseButton.alpha = 0;
        }];
    }

}

-(void)drawChartWithOrintation:(UIDeviceOrientation)orintation{
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
        
        [self setDataCount:12 range:50];
    }
    [self.view addSubview:_chartView];
    
    [UIView animateWithDuration:0.5 animations:^(void){
        _chartView.alpha = 1;
    }];

}

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

- (IBAction)expenseSwiped:(UISwipeGestureRecognizer *)sender {
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

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *xVals = [[CoreDataHelper sharedCLCoreDataHelper]collectFinalBalanceDate];
    
    NSMutableArray *yVals = [[CoreDataHelper sharedCLCoreDataHelper]collectFinalBalanceAmount];
    BarChartDataEntry *last = [yVals objectAtIndex:yVals.count-1];
    NSString *lastStr = [NSString stringWithFormat:@"%f",last.value];
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:[self currencyFormString:lastStr]];
    set1.barSpace = 0.35;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:5.f]];
    
    _chartView.data = data;
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



@end
