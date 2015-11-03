//
//  SDetailViewController.m
//  Save
//
//  Created by Abbin on 20/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "SDetailViewController.h"
#import "SCollectionViewCell.h"
#import "AppDelegate.h"
#include <Photos/Photos.h>
#import "UICollectionView+UICollectionView_Convenience.h"
#import "NSIndexSet+NSIndexSet_Convenience.h"


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_4s ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@interface SDetailViewController ()<PHPhotoLibraryChangeObserver>

{
    NSDate *newDate1;
    int buttonHeight;
    int buttonWidth;
    NSArray *typeArray;
}

@property (nonatomic, strong) NSArray *sectionFetchResults;
@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property CGRect previousPreheatRect;


@property (strong, nonatomic) UICollectionView *photoGallary;

@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *currenzyLabel;

@property(nonatomic,strong)NSMutableString *amount;

@property (weak, nonatomic) IBOutlet AKPickerView *pickerViewCustom;

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

@property (strong, nonatomic)  UITextView *notesView;
@property (strong, nonatomic) UILabel *placeHolderText;
@property (strong, nonatomic)  UILabel *dateView;
@property (strong, nonatomic)  SButton *imageButtonView;

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
@property (nonatomic,strong) NSDate *selectedDate;

@end


@implementation SDetailViewController

static CGSize AssetGridThumbnailSize;

- (void)awakeFromNib {
    self.imageManager = [[PHCachingImageManager alloc] init];
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self resetCachedAssets];
        
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
}

- (void)dealloc {
    if ([PHPhotoLibrary authorizationStatus]== PHAuthorizationStatusAuthorized) {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    buttonWidth = [UIScreen mainScreen].bounds.size.width/3;
    buttonHeight = [UIScreen mainScreen].bounds.size.height/2/4;
    [self drawPrimaryView];
    self.selectedDate = [NSDate date];
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
        typeArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"income"];
        self.pickerViewCustom.backgroundColor = [UIColor colorWithRed:0.9 green:1 blue:0.9 alpha:1];
    }
    else{
        typeArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"expense"];
        self.pickerViewCustom.backgroundColor = [UIColor colorWithRed:1 green:0.9 blue:0.9 alpha:1];
    }

    self.amount = [NSMutableString string];
    if (IS_IPHONE_5) {
        self.amountLabel.font = [UIFont fontWithName:@"EuropeUnderground-Light" size:53];
    }
    else if (IS_IPHONE_4s){
        self.amountLabel.font = [UIFont fontWithName:@"EuropeUnderground-Light" size:53];
    }
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Begin caching assets in and around collection view's visible rect.
    [self updateCachedAssets];
    
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

-(void)dismissView{
    [UIView animateWithDuration:0.3 animations:^(void){
        self.view.backgroundColor = [UIColor whiteColor];
        self.saveLabel.alpha = 0;
        self.cancelLabel.alpha = 0;
    }completion:^(BOOL finished){
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark-
#pragma mark - AKPickerViewDelegate

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView{
    return typeArray.count;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item{
    return [typeArray objectAtIndex:item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item{
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark-
#pragma mark Initilize and Draw Methods

-(void)drawPrimaryView{
    self.innerView.frame = [UIScreen mainScreen].bounds;
    self.point.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-buttonHeight, buttonWidth, buttonHeight);
    self.zero.frame = CGRectMake(buttonWidth, [UIScreen mainScreen].bounds.size.height-buttonHeight, buttonWidth, buttonHeight);
    self.cancel.frame = CGRectMake(buttonWidth*2, [UIScreen mainScreen].bounds.size.height-buttonHeight, buttonWidth, buttonHeight);
    self.seven.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-buttonHeight*2, buttonWidth, buttonHeight);
    self.eight.frame = CGRectMake(buttonWidth, [UIScreen mainScreen].bounds.size.height-buttonHeight*2, buttonWidth, buttonHeight);
    self.nine.frame = CGRectMake(buttonWidth*2, [UIScreen mainScreen].bounds.size.height-buttonHeight*2, buttonWidth, buttonHeight);
    self.four.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-buttonHeight*3, buttonWidth, buttonHeight);
    self.five.frame = CGRectMake(buttonWidth, [UIScreen mainScreen].bounds.size.height-buttonHeight*3, buttonWidth, buttonHeight);
    self.six.frame = CGRectMake(buttonWidth*2, [UIScreen mainScreen].bounds.size.height-buttonHeight*3, buttonWidth, buttonHeight);
    self.one.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-buttonHeight*4, buttonWidth, buttonHeight);
    self.two.frame = CGRectMake(buttonWidth, [UIScreen mainScreen].bounds.size.height-buttonHeight*4, buttonWidth, buttonHeight);
    self.three.frame = CGRectMake(buttonWidth*2, [UIScreen mainScreen].bounds.size.height-buttonHeight*4, buttonWidth, buttonHeight);
    
    self.cancelLabel.frame = CGRectMake(-32.5, [UIScreen mainScreen].bounds.size.height/2, 65, 25);
    self.saveLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-23, [UIScreen mainScreen].bounds.size.height/2, 46, 25);
    self.amountLabel.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height/4-20);
    self.currenzyLabel.frame = CGRectMake(self.amountLabel.frame.size.width, 20, 20, [UIScreen mainScreen].bounds.size.height/4-20);
    self.pickerViewCustom.frame = CGRectMake(0, self.amountLabel.frame.size.height+20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/4);
}

-(void)initSecondryUIElements{
    if (!self.notesView) {
        self.notesView = [[UITextView alloc]initWithFrame:CGRectMake(0, self.pickerViewCustom.frame.size.height+20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/4-50)];
        [self.innerView addSubview:self.notesView];
    }
    self.notesView.backgroundColor = [UIColor whiteColor];
    self.notesView.alpha = 0;
    
    if (!self.placeHolderText) {
        self.placeHolderText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    }
    self.placeHolderText.center = self.notesView.center;
    self.placeHolderText.text = @"notes";
    [self.placeHolderText setTextAlignment:NSTextAlignmentCenter];
    self.placeHolderText.alpha = 0;
    [self.placeHolderText setBackgroundColor:[UIColor clearColor]];
    [self.placeHolderText setFont:[UIFont fontWithName:@"Adequate-ExtraLight" size:15]];
    [self.innerView addSubview:self.placeHolderText];
    
    if (!self.dateView) {
        self.dateView = [[UILabel alloc]initWithFrame:CGRectMake(0, self.notesView.frame.size.height+self.pickerViewCustom.frame.size.height+20, [UIScreen mainScreen].bounds.size.width, 30)];
        UIPanGestureRecognizer *datePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanDateButton:)];
        self.dateView.userInteractionEnabled = YES;
        [self.dateView addGestureRecognizer:datePan];
        [self.innerView addSubview:self.dateView];
    }
    
    self.dateView.backgroundColor = [UIColor whiteColor];
    self.dateView.alpha = 0;
    [self.dateView setTextColor:[UIColor blackColor]];
    [self.dateView setTextAlignment:NSTextAlignmentCenter];
    self.dateView.font = [UIFont fontWithName:@"Adequate-ExtraLight" size:15];
    self.dateView.text = @"today";
    
    
    if (!self.imageButtonView) {
        self.imageButtonView = [[SButton alloc]initWithFrame:CGRectMake(0,
                                                                        [UIScreen mainScreen].bounds.size.height/2,
                                                                        [UIScreen mainScreen].bounds.size.width,
                                                                        [UIScreen mainScreen].bounds.size.height/2)];
        [self.innerView addSubview:self.imageButtonView];
    }
    [self.imageButtonView setTitle:@"add image" forState:UIControlStateNormal];
    [self.imageButtonView.titleLabel setFont:[UIFont fontWithName:@"EuropeUnderground-Light" size:20]];
    [self.imageButtonView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.imageButtonView.alpha = 0;
    self.imageButtonView.delegate = self;
    self.imageButtonView.backgroundColor = [UIColor clearColor];
    [self.innerView addSubview:self.imageButtonView];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark-
#pragma mark UICollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Set the cell's thumbnail image if it's still showing the same asset.
                                  
                                  cell.imageViewC.image = result;
                                  
                              }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    double ss= [UIScreen mainScreen].bounds.size.height/4-5;
    return CGSizeMake(ss, ss);
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark-
#pragma mark Action Methods

-(void)didTapSButton:(SButton *)button{
    if ([self.notesView isFirstResponder]) {
        [self.view endEditing:YES];
    }
    else{
        [self.imageButtonView setTitle:@"accessing...." forState:UIControlStateNormal];
        [self performSelector:@selector(getAllPictures) withObject:nil afterDelay:1];
    }
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


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark-
#pragma mark GestureRecognizers & Animate Methods

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

- (IBAction)didSwipeDownNumPads:(UISwipeGestureRecognizer *)sender {
    [self animateIntoOptions];
    [self initSecondryUIElements];
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
            self.notesView.alpha = 1;
            self.dateView.alpha = 1;
            self.placeHolderText.alpha = 0.5;
            self.dateView.layer.borderWidth = 1;
            self.dateView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
            if (self.assetsFetchResults.count==0 || self.assetsFetchResults == nil) {
                self.imageButtonView.alpha = 1;
            }
            if (self.assetsFetchResults.count>0) {
                self.photoGallary.alpha = 1;
            }
            
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
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^(void){
        self.notesView.alpha = 0;
        self.dateView.alpha = 0;
        self.placeHolderText.alpha = 0;
        self.imageButtonView.alpha = 0;
        self.photoGallary.alpha = 0;
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

- (void)didPanDateButton:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.selectedDate = newDate1;
    }
    else{
        CGPoint tran = [sender translationInView:self.view];
        NSString *string = [NSString stringWithFormat:@"%i",(int)tran.y];
        if (string.length>1) {
            string = [string substringToIndex:[string length]-1];
        }
        newDate1 = [self.selectedDate dateByAddingTimeInterval:60*60*24*[string intValue]];
        NSDateFormatter *form = [[NSDateFormatter alloc]init];
        [form setDateFormat:@"dd MMMM yyyy"];
        [self.dateView setText:[form stringFromDate:newDate1]];
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)allPhotosCollected{
    [self.photoGallary reloadData];
    self.imageButtonView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^(void){
        self.photoGallary.alpha = 1;
    }completion:^(BOOL finished){
        [self.imageButtonView removeFromSuperview];
    }];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark-
#pragma mark Photo Manage Methods

-(void)getAllPictures{
    if ([PHPhotoLibrary authorizationStatus]==PHAuthorizationStatusAuthorized) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.photoGallary=[[UICollectionView alloc] initWithFrame:self.imageButtonView.frame collectionViewLayout:layout];
        [self.photoGallary setDataSource:self];
        [self.photoGallary setDelegate:self];
        [self.photoGallary registerClass:[SCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [self.photoGallary setBackgroundColor:[UIColor whiteColor]];
        self.photoGallary.alpha = 0;
        [self.innerView addSubview:self.photoGallary];
        
        // Create a PHFetchResult object for each section in the table view.
        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize cellSize = ((UICollectionViewFlowLayout *)layout).itemSize;
        AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
        [self allPhotosCollected];
    }
    else{
        [self photoAccessDeniedProtocol];
    }
    
}

-(void)photoAccessDeniedProtocol{
    self.imageButtonView.enabled = NO;
    [self performSelector:@selector(setImageButtonTitleAccessDenied) withObject:nil afterDelay:0];
    [self performSelector:@selector(setImageButtonTitletwo) withObject:nil afterDelay:3];
    [self performSelector:@selector(setImageButtonTitlethree) withObject:nil afterDelay:6];
    [self performSelector:@selector(setImageButtonTitlefour) withObject:nil afterDelay:9];
    [self performSelector:@selector(photoAccessDeniedProtocol) withObject:nil afterDelay:12];
}

-(void)setImageButtonTitleAccessDenied{
    [self.imageButtonView setTitle:@"access to photo library denied" forState:UIControlStateNormal];
}

-(void)setImageButtonTitletwo{
    [self.imageButtonView setTitle:@"go to settings" forState:UIControlStateNormal];
}

-(void)setImageButtonTitlethree{
    [self.imageButtonView setTitle:@"save app" forState:UIControlStateNormal];
}

-(void)setImageButtonTitlefour{
    [self.imageButtonView setTitle:@"turn on Photo" forState:UIControlStateNormal];
}

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.photoGallary.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.photoGallary.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.photoGallary aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.photoGallary aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    [self updateCachedAssets];
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // Check if there are changes to the assets we are showing.
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the new fetch result.
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        
        UICollectionView *collectionView = self.photoGallary;
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            // Reload the collection view if the incremental diffs are not available
            [collectionView reloadData];
            
        } else {
            /*
             Tell the collection view to animate insertions and deletions if we
             have incremental diffs.
             */
            [collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                if ([removedIndexes count] > 0) {
                    [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
                    [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                if ([changedIndexes count] > 0) {
                    [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
            } completion:NULL];
        }
        
        [self resetCachedAssets];
    });
}

@end
