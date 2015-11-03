//
//  SLabel.m
//  Save
//
//  Created by Abbin on 30/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "SLabel.h"

@implementation SLabel

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.shouldTouch = YES;
    }
    return self;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.shouldTouch) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.center = CGPointMake(self.center.x-5, self.center.y-5);
        }completion:^(BOOL finished){
            
        }];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.shouldTouch) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            self.center = CGPointMake(self.center.x+5, self.center.y+5);
        }completion:^(BOOL finished){
            
        }];
    }
}


-(void)drawRect:(CGRect)rect withShadow:(BOOL)shadow{
    [self setFrame:rect];
    if (shadow) {
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(5.0f, 0.0f);
        self.layer.shadowOpacity = 0;
        self.layer.shadowPath = shadowPath.CGPath;
    }
}

@end
