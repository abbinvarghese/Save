//
//  SView.m
//  Save
//
//  Created by Abbin on 19/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "SView.h"


@implementation SView


- (void)drawRect:(CGRect)rect {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.layer.shadowPath = shadowPath.CGPath;
    
    self.touchesDidEnd = YES;
    self.shouldTouch = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.shouldTouch) {
        if (self.touchesDidEnd) {
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
            anim.fromValue = [NSNumber numberWithFloat:0.0];
            anim.toValue = [NSNumber numberWithFloat:0.5];
            anim.duration = 0.3;
            [self.layer addAnimation:anim forKey:@"shadowOpacity"];
            self.layer.shadowOpacity = 0.5;
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            int screenWidth = screenRect.size.width;
            int screenHeight = screenRect.size.height;
            if (screenHeight % 2) {
                screenHeight++;
            }
            int middle = screenHeight/2;
            int middleOfMiddle = middle/2;

            
            if (self.viewTag == 0) {
                [UIView animateWithDuration:0.3 animations:^(void) {
                    self.center = CGPointMake((screenWidth/2)-3, middleOfMiddle-3);
                }];
            }
            else{
                [UIView animateWithDuration:0.3 animations:^(void) {
                    self.center = CGPointMake((screenWidth/2)-3, middle+middleOfMiddle-3);
                }];
            }
        }
        self.touchesDidEnd = NO;
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.shouldTouch) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        anim.fromValue = [NSNumber numberWithFloat:0.5];
        anim.toValue = [NSNumber numberWithFloat:0.0];
        anim.duration = 0.3;
        [self.layer addAnimation:anim forKey:@"shadowOpacity"];
        self.layer.shadowOpacity = 0.0;
        self.touchesDidEnd = YES;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        int screenWidth = screenRect.size.width;
        int screenHeight = screenRect.size.height;
        if (screenHeight % 2) {
            screenHeight++;
        }
        int middle = screenHeight/2;
        int middleOfMiddle = middle/2;
        
        
        if (self.viewTag == 0) {
            [UIView animateWithDuration:0.3 animations:^(void) {
                self.center = CGPointMake(screenWidth/2, middleOfMiddle);
            }];
        }
        else{
            [UIView animateWithDuration:0.3 animations:^(void) {
                self.center = CGPointMake(screenWidth/2, middle+middleOfMiddle-1);
            }];
        }
        
    }
}




@end
