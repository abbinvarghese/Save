//
//  SCollectionViewCell.m
//  Save
//
//  Created by Abbin on 02/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "SCollectionViewCell.h"

@implementation SCollectionViewCell

- (void)awakeFromNib {

}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        self.imageViewC.layer.cornerRadius = 5;
        self.imageViewC.layer.masksToBounds = YES;
    }
    
    
    return self;
}

@end
