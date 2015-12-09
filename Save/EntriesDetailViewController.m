//
//  EntriesDetailViewController.m
//  Save
//
//  Created by Abbin on 09/12/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "EntriesDetailViewController.h"

@interface EntriesDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UITextView *notesTextView;
@property (strong, nonatomic) UIImageView *imageLabel;

@end

@implementation EntriesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    // Do any additional setup after loading the view from its nib.
}

-(void)drawView{
    self.amountLabel.frame = CGRectMake(0,
                                        64,
                                        [UIScreen mainScreen].bounds.size.width/2,
                                        [UIScreen mainScreen].bounds.size.height/12);
    self.amountLabel.text = [self currencyFormString:[NSString stringWithFormat:@"%@",self.obj.amount]];
    
    self.typeLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2,
                                      64,
                                      [UIScreen mainScreen].bounds.size.width/2,
                                      [UIScreen mainScreen].bounds.size.height/12);
    self.typeLabel.text = [NSString stringWithFormat:@"%@",self.obj.type];
    
    self.dateLabel.frame = CGRectMake(0,
                                      self.amountLabel.frame.size.height+64,
                                      [UIScreen mainScreen].bounds.size.width,
                                      [UIScreen mainScreen].bounds.size.height/17);
    self.dateLabel.text = [NSString stringWithFormat:@"%@",self.obj.date];
    
    if (self.obj.note.length>0) {
        self.notesTextView = [[UITextView alloc]initWithFrame:CGRectMake(0,
                                                                         self.dateLabel.frame.size.height+self.amountLabel.frame.size.height+64,
                                                                         [UIScreen mainScreen].bounds.size.width,
                                                                         [UIScreen mainScreen].bounds.size.height/3)];
        self.notesTextView.editable = NO;
        self.notesTextView.text = self.obj.note;
        [self.view addSubview:self.notesTextView];
    }
    if (self.obj.attachment) {
        self.imageLabel = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                       self.notesTextView.frame.size.height+self.dateLabel.frame.size.height+self.amountLabel.frame.size.height+64,[UIScreen mainScreen].bounds.size.width,
                                                                       [UIScreen mainScreen].bounds.size.height/2.35)];
        self.imageLabel.image = [UIImage imageWithData:self.obj.attachment];
        [self.imageLabel setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:self.imageLabel];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
