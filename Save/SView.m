//
//  SView.m
//  Save
//
//  Created by Abbin on 19/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "SView.h"
#define kraiseAnimation @"raise"
#define klowerAnimation @"lower"

@implementation SView


- (void)drawRect:(CGRect)rect {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.layer.shadowPath = shadowPath.CGPath;
    
    self.raiseAnimation = [POPBasicAnimation animation];
    self.raiseAnimation.name = kraiseAnimation;
    self.raiseAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    self.raiseAnimation.toValue=[NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y-5)];
    self.raiseAnimation.delegate=self;
    
    self.lowerAnimation = [POPBasicAnimation animation];
    self.lowerAnimation.name = klowerAnimation;
    self.lowerAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    self.lowerAnimation.toValue=[NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)];
    self.lowerAnimation.delegate=self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self pop_addAnimation:self.raiseAnimation forKey:kraiseAnimation];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self pop_addAnimation:self.lowerAnimation forKey:klowerAnimation];
}

- (void)pop_animationDidStart:(POPAnimation *)anim{
    if ([anim.name isEqualToString:kraiseAnimation]) {
        self.layer.shadowOpacity = 0.5f;
    }
    else{
        
    }
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    if ([anim.name isEqualToString:kraiseAnimation]) {
        
    }
    else{
        self.layer.shadowOpacity = 0.0f;
    }
    
}

@end
