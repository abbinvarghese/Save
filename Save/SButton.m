//
//  SButton.m
//  Save
//
//  Created by Abbin on 02/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "SButton.h"

@implementation SButton

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.center = CGPointMake(self.center.x-1, self.center.y-1);
            self.alpha = 0.5;
        }completion:^(BOOL finished){
            
        }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.center = CGPointMake(self.center.x+1, self.center.y+1);
            self.alpha = 1;
        }completion:^(BOOL finished){
            if ([self.delegate respondsToSelector:@selector(didTapSButton:)]) {
                [self.delegate didTapSButton:self];
            }
        }];
}



@end
