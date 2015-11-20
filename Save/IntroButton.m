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
        [self setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [self setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
        [self setAlpha:0];
    }
    return self;
}

@end
