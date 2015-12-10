//
//  DetailTableViewCell.m
//  Save
//
//  Created by Abbin on 10/12/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    self.attachmentView.layer.cornerRadius = self.attachmentView.layer.frame.size.width/2;
    self.attachmentView.layer.masksToBounds = YES;
    self.dateLabel.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.obj) {
        if (self.obj.attachment) {
            self.attachmentView.image = [UIImage imageWithData:self.obj.attachment];
        }
        if (self.obj.note.length>0) {
            self.notesLabel.text = self.obj.note;
        }
        if (self.obj.isIncome) {
            self.typeLabel.backgroundColor = [UIColor colorWithRed:0.9 green:1 blue:0.9 alpha:1];
            self.amountLabel.backgroundColor = [UIColor colorWithRed:0.9 green:1 blue:0.9 alpha:1];
        }
        else{
            self.typeLabel.backgroundColor = [UIColor colorWithRed:1 green:0.9 blue:0.9 alpha:1];
            self.amountLabel.backgroundColor = [UIColor colorWithRed:1 green:0.9 blue:0.9 alpha:1];
        }
        self.amountLabel.text = [self currencyFormString:[NSString stringWithFormat:@"%@",self.obj.amount]];
        self.typeLabel.text = self.obj.type;
        NSDateFormatter *form = [[NSDateFormatter alloc]init];
        [form setDateFormat:@"dd MMMM yyyy"];
        self.dateLabel.text = [form stringFromDate:self.obj.date];
    }
    // Configure the view for the selected state
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