//
//  IntroCollectionViewCellThree.m
//  Save
//
//  Created by Abbin on 20/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "IntroCollectionViewCellThree.h"
#import "SIntroLabel.h"

@implementation IntroCollectionViewCellThree

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"IntroCollectionViewCellThree" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        [self DrawFour];
    }
    
    return self;
}

-(void)DrawFour{
    self.nextButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-70, [UIScreen mainScreen].bounds.size.width, 70);
    
    SIntroLabel *smileLabel = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width, 50)];
    smileLabel.text = @"all done";
    [self addSubview:smileLabel];;
    
    SIntroLabel *smileLabel2 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50, [UIScreen mainScreen].bounds.size.width, 50)];
    smileLabel2.text = @"see your chart";
    [self addSubview:smileLabel2];
    
    SIntroLabel *smileLabel3 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50*2, [UIScreen mainScreen].bounds.size.width, 50)];
    smileLabel3.text = @"under the income";
    [self addSubview:smileLabel3];
    
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.nextButton.alpha = 1;
        smileLabel.alpha = 1;
        smileLabel2.alpha = 1;
        smileLabel3.alpha = 1;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            
            smileLabel.center = CGPointMake(smileLabel.center.x, smileLabel.center.y-70);
            smileLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            
        }completion:^(BOOL finished){
            
        }];
        
        [UIView animateWithDuration:1 delay:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            
            smileLabel2.center = CGPointMake(smileLabel2.center.x, smileLabel2.center.y-70);
            smileLabel2.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            
        }completion:^(BOOL finished){
            
        }];
        
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            
            smileLabel3.center = CGPointMake(smileLabel3.center.x, smileLabel3.center.y-70);
            smileLabel3.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            
        }completion:^(BOOL finished){
            
        }];
    }];
    
    


}

@end
