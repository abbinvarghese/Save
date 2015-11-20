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
#import "IntroCollectionViewController.h"

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
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *incomeTap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *expenceTap;

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
    [self didSwipeDownOnUpperView:nil];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^(void){
        self.incomeButton.alpha = 1;
        self.expenseButton.alpha = 1;
    }];
    
    
    
    // CREATES THE TYPE ARRAYS IN USER DEFAULTS AND LAUNCHS THE INTRO SCREEN IF ITS THE FIRST TIME LAUNCH
    //if (![[NSUserDefaults standardUserDefaults] objectForKey:@"expense"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *expense = [[NSArray alloc]initWithObjects:@"Travel",@"Food & Drinks",@"Bills",@"Entertainment",@"Shopping",@"Healthcare",@"Clothing",@"Education",@"Rent",@"Gifts", nil];
        NSArray *income = [[NSArray alloc]initWithObjects:@"Salary", @"Business",@"Loans",@"Gifts", @"Shares", nil];
        [defaults setObject:expense forKey:@"expense"];
        [defaults setObject:income forKey:@"income"];
        [defaults synchronize];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        IntroCollectionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"IntroCollectionViewController"];
        [self presentViewController:vc animated:NO completion:^(void){
            
        }];
   // }

}

- (IBAction)didSwipeDownOnUpperView:(UISwipeGestureRecognizer *)sender {
    
    self.incomeButton.shouldTouch = NO;
    self.incomeTap.enabled = NO;
    self.expenseButton.enabled=NO;
    self.expenceTap.enabled=NO;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.incomeButton.center = CGPointMake(screenWidth/2,middle + middleOfMiddle+50);
        self.incomeButton.layer.shadowOpacity = 1;
    }completion:^(BOOL finished){
        if (!_chartView) {
            _chartView = [[BarChartView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
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
            xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
            xAxis.drawGridLinesEnabled = NO;
            xAxis.enabled = NO;
            
            ChartYAxis *leftAxis = _chartView.leftAxis;
            leftAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
            leftAxis.labelCount = 6;
            leftAxis.startAtZeroEnabled = NO;
            leftAxis.axisMinimum = -2.5;
            leftAxis.axisMaximum = 2.5;
            
            ChartYAxis *rightAxis = _chartView.rightAxis;
            rightAxis.drawGridLinesEnabled = NO;
            rightAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
            rightAxis.labelCount = 6;
            rightAxis.startAtZeroEnabled = NO;
            rightAxis.axisMinimum = -2.5;
            rightAxis.axisMaximum = 2.5;
            
            ChartLegend *l = _chartView.legend;
            l.position = ChartLegendPositionBelowChartLeft;
            l.form = ChartLegendFormSquare;
            l.formSize = 9.0;
            l.font = [UIFont systemFontOfSize:11.f];
            l.xEntrySpace = 4.0;
            [self setDataCount:20];
            [_chartView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
            _chartView.alpha = 0;
            [self.view insertSubview:_chartView atIndex:0];
            [UIView animateWithDuration:0.5 animations:^(void){
                 _chartView.alpha = 1;
            }];
        }
    }];
}

- (IBAction)didSwipeUpOnUpperView:(UISwipeGestureRecognizer *)sender {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.incomeButton.center = CGPointMake(screenWidth/2,middleOfMiddle);
    }completion:^(BOOL finished){
        self.incomeButton.layer.shadowOpacity = 0;
        self.incomeButton.shouldTouch = YES;
        self.incomeTap.enabled = YES;
        self.expenseButton.enabled=YES;
        self.expenceTap.enabled=YES;
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

- (void)setDataCount:(int)count
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
        [xVals addObject:@"da"];
        [entries addObject:[[BarChartDataEntry alloc] initWithValue:23 xIndex:0]];
    [xVals addObject:@"da"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:23 xIndex:1]];
    [xVals addObject:@"adsa"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:11 xIndex:2]];
    [xVals addObject:@"dasda"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:42 xIndex:3]];
    [xVals addObject:@"dsada"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:-11 xIndex:4]];
    [xVals addObject:@"dara"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:-54 xIndex:5]];
    [xVals addObject:@"dsgdfa"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:22 xIndex:6]];
    [xVals addObject:@"gsdfda"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:54 xIndex:7]];
    [xVals addObject:@"daxxc"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:12 xIndex:8]];
    [xVals addObject:@"dkya"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:-11 xIndex:9]];
    [xVals addObject:@"dtya"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:42 xIndex:10]];
    [xVals addObject:@"dsfdga"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:99 xIndex:11]];
    [xVals addObject:@"dytuia"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:-54 xIndex:12]];
    [xVals addObject:@"d67a"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:-12 xIndex:13]];
    [xVals addObject:@"dafg"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:23 xIndex:14]];
    [xVals addObject:@"dwya"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:23 xIndex:15]];
    [xVals addObject:@"drtha"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:11 xIndex:16]];
    [xVals addObject:@"65"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:42 xIndex:17]];
    [xVals addObject:@"d56ja"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:-11 xIndex:18]];
    [xVals addObject:@"dhwa"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:-54 xIndex:19]];
    [xVals addObject:@"hgfh"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:22 xIndex:20]];
    [xVals addObject:@"sth"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:54 xIndex:21]];
    [xVals addObject:@"y43"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:12 xIndex:22]];
    [xVals addObject:@"o9"];
    [entries addObject:[[BarChartDataEntry alloc] initWithValue:-11 xIndex:23]];
    [xVals addObject:@"dasgf"];


    
    BarChartDataSet *set = [[BarChartDataSet alloc] initWithYVals:entries label:@"Sinus Function"];
    set.barSpace = 0.4;
    [set setColor:[UIColor colorWithRed:240/255.f green:120/255.f blue:124/255.f alpha:1.f]];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSet:set];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    [data setDrawValues:NO];
    
    _chartView.data = data;
}


@end
