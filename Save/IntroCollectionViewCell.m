//
//  IntroCollectionViewCell.m
//  Save
//
//  Created by Abbin on 19/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "IntroCollectionViewCell.h"


@implementation IntroCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"IntroCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];

    }
    
    return self;
}

-(void)drawCellWithIndexPath:(NSIndexPath *)indexPath{
    self.cellIndexPath = indexPath;
    if (self.cellIndexPath.row == 0) {
        [self drawFirst];
    }
    else if (self.cellIndexPath.row == 1){
        [self drawSecond];
    }
    else if (YES){
        self.cellImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height-100)];
        self.cellImageView.backgroundColor = [UIColor blackColor];
        self.cellImageView.layer.cornerRadius = 5;
        self.cellImageView.layer.masksToBounds = YES;
        [self addSubview:self.cellImageView];
    }
    
    self.cellNextButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-70, [UIScreen mainScreen].bounds.size.width, 70);
}


-(void)drawSecond{
    
    if (!self.smileLabel) {
        self.smileLabel = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width, 50)];
        [self addSubview:self.smileLabel];
    }
    self.smileLabel.text = @"set a monthly";

    
    if (!self.smileLabel2) {
        self.smileLabel2 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50, [UIScreen mainScreen].bounds.size.width, 50)];
        [self addSubview:self.smileLabel2];
    }
    self.smileLabel2.text = @"limit";
    
    if (!self.smileLabel3) {
        self.smileLabel3 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50*2, [UIScreen mainScreen].bounds.size.width, 50)];
        [self addSubview:self.smileLabel3];
    }
    self.smileLabel3.text = @"which is then used in";
    
    if (!self.smileLabel4) {
        self.smileLabel4 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50*3, [UIScreen mainScreen].bounds.size.width, 50)];
        [self addSubview:self.smileLabel4];
    }
    self.smileLabel4.text = @"calculating";
    
    if (!self.smileLabel5) {
        self.smileLabel5 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50*4, [UIScreen mainScreen].bounds.size.width, 50)];
        [self addSubview:self.smileLabel5];
    }
    self.smileLabel5.text = @"your";
    
    if (!self.smileLabel6) {
        self.smileLabel6 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50*5, [UIScreen mainScreen].bounds.size.width, 50)];
        [self addSubview:self.smileLabel6];
    }
    self.smileLabel6.text = @"monthly balance";
    
    [self animatelabel];
}

-(void)drawFirst{
    self.smileLabel = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width, 50)];
    self.smileLabel.text = @"save helps you";
    [self addSubview:self.smileLabel];;
    
    self.smileLabel2 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50, [UIScreen mainScreen].bounds.size.width, 50)];
    self.smileLabel2.text = @"manage your savings";
    [self addSubview:self.smileLabel2];
    
    self.smileLabel3 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50*2, [UIScreen mainScreen].bounds.size.width, 50)];
    self.smileLabel3.text = @"by";
    [self addSubview:self.smileLabel3];
    
    self.smileLabel4 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50*3, [UIScreen mainScreen].bounds.size.width, 50)];
    self.smileLabel4.text = @"keeping a";
    [self addSubview:self.smileLabel4];
    
    self.smileLabel5 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50*4, [UIScreen mainScreen].bounds.size.width, 50)];
    self.smileLabel5.text = @"monthly limit";
    [self addSubview:self.smileLabel5];
    
    self.smileLabel6 = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5+50*5, [UIScreen mainScreen].bounds.size.width, 50)];
    self.smileLabel6.text = @"on your expences";
    [self addSubview:self.smileLabel6];
    
    [self animatelabel];
}

-(void)animatelabel{
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.cellNextButton.alpha = 1;
        self.smileLabel.alpha = 1;
        self.smileLabel2.alpha = 1;
        self.smileLabel3.alpha = 1;
        self.smileLabel4.alpha = 1;
        self.smileLabel5.alpha = 1;
        self.smileLabel6.alpha = 1;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            self.smileLabel.center = CGPointMake(self.smileLabel.center.x, self.smileLabel.center.y-50);
            self.smileLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            self.smileLabel.alpha = 0.5;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:5 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            self.smileLabel2.center = CGPointMake(self.smileLabel2.center.x, self.smileLabel2.center.y-50);
            self.smileLabel2.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            self.smileLabel2.alpha = 0.5;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:5 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            self.smileLabel3.center = CGPointMake(self.smileLabel3.center.x, self.smileLabel3.center.y-50);
            self.smileLabel3.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            self.smileLabel3.alpha = 0.5;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:5 delay:4 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            self.smileLabel4.center = CGPointMake(self.smileLabel4.center.x, self.smileLabel4.center.y-50);
            self.smileLabel4.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            self.smileLabel4.alpha = 0.5;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:5 delay:5 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            self.smileLabel5.center = CGPointMake(self.smileLabel5.center.x, self.smileLabel5.center.y-50);
            self.smileLabel5.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            self.smileLabel5.alpha = 0.5;
        }completion:^(BOOL finished){
            
        }];
        [UIView animateWithDuration:5 delay:6 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            self.smileLabel6.center = CGPointMake(self.smileLabel6.center.x, self.smileLabel6.center.y-50);
            self.smileLabel6.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            self.smileLabel6.alpha = 0.5;
        }completion:^(BOOL finished){
            [UIView animateWithDuration:5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                self.smileLabel.center = CGPointMake(self.smileLabel.center.x, self.smileLabel.center.y+50);
                self.smileLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                self.smileLabel.alpha = 1;
            }completion:^(BOOL finished){
                
            }];
            [UIView animateWithDuration:5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                self.smileLabel2.center = CGPointMake(self.smileLabel2.center.x, self.smileLabel2.center.y+50);
                self.smileLabel2.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                self.smileLabel2.alpha = 1;
            }completion:^(BOOL finished){
                
            }];
            [UIView animateWithDuration:5 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                self.smileLabel3.center = CGPointMake(self.smileLabel3.center.x, self.smileLabel3.center.y+50);
                self.smileLabel3.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                self.smileLabel3.alpha = 1;
            }completion:^(BOOL finished){
                
            }];
            [UIView animateWithDuration:5 delay:2.5 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                self.smileLabel4.center = CGPointMake(self.smileLabel4.center.x, self.smileLabel4.center.y+50);
                self.smileLabel4.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                self.smileLabel4.alpha = 1;
            }completion:^(BOOL finished){
                
            }];
            [UIView animateWithDuration:5 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                self.smileLabel5.center = CGPointMake(self.smileLabel5.center.x, self.smileLabel5.center.y+50);
                self.smileLabel5.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                self.smileLabel5.alpha = 1;
            }completion:^(BOOL finished){
                
            }];
            [UIView animateWithDuration:5 delay:3.5 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                self.smileLabel6.center = CGPointMake(self.smileLabel6.center.x, self.smileLabel6.center.y+50);
                self.smileLabel6.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                self.smileLabel6.alpha = 1;
            }completion:^(BOOL finished){
        
            }];

        }];
    }];
}

- (IBAction)buttonPress:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(introCelldidtapNext:)]) {
        [self.delegate introCelldidtapNext:self];
    }
}

@end
