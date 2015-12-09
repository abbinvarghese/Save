//
//  EntriesDetailViewController.m
//  Save
//
//  Created by Abbin on 09/12/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "EntriesDetailViewController.h"

#define IS_IPHONE_4s ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6Plus ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

@interface EntriesDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentView;
@property (weak, nonatomic) IBOutlet UILabel *noImageLabel;

@end

@implementation EntriesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_4s) {
        self.attachmentView.layer.cornerRadius = self.attachmentView.frame.size.width/2;
    }
    else if (IS_IPHONE_5){
        self.attachmentView.layer.cornerRadius = self.attachmentView.frame.size.width/2;
    }
    else if(IS_IPHONE_6){
        self.attachmentView.layer.cornerRadius = self.attachmentView.frame.size.width/1.6;
    }
    else if (IS_IPHONE_6Plus){
        self.attachmentView.layer.cornerRadius = self.attachmentView.frame.size.width/1.4;
    }
    self.attachmentView.clipsToBounds = YES;
    self.dateLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.dateLabel.layer.borderWidth = 0.5;
    self.typeLabel.text = self.obj.type;
    self.amountLabel.text = [self currencyFormString:[NSString stringWithFormat:@"%@",self.obj.amount]];
    if (self.obj.isIncome) {
        self.amountLabel.backgroundColor = [UIColor colorWithRed:0.9 green:1 blue:0.9 alpha:1];
        self.typeLabel.backgroundColor = [UIColor colorWithRed:0.9 green:1 blue:0.9 alpha:1];
    }
    else{
        self.typeLabel.backgroundColor = [UIColor colorWithRed:0.9 green:1 blue:0.9 alpha:1];
        self.amountLabel.backgroundColor = [UIColor colorWithRed:1 green:0.9 blue:0.9 alpha:1];
    }
    if (self.obj.note.length>0) {
        self.notesLabel.text = self.obj.note;
    }
    if (self.obj.attachment) {
        self.attachmentView.image = [UIImage imageWithData:self.obj.attachment];
        self.noImageLabel.hidden = YES;
    }
    // Do any additional setup after loading the view from its nib.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
