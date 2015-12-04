//
//  IntroButton.m
//  Save
//
//  Created by Abbin on 20/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "IntroButton.h"

@implementation IntroButton

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:(CGRect)frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Ultralight" size:25]];
        [self setAlpha:0];
    }
    return self;
}

@end
