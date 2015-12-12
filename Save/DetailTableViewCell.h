//
//  DetailTableViewCell.h
//  Save
//
//  Created by Abbin on 10/12/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entries+CoreDataProperties.h"

@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property(nonatomic,strong)Entries *obj;

@end
