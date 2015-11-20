//
//  SIntroLabel.m
//  Save
//
//  Created by Abbin on 19/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "SIntroLabel.h"

@implementation SIntroLabel

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:(CGRect)frame]) {
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setFont:[UIFont fontWithName:@"Adequate-ExtraLight" size:20]];
        [self setAlpha:0];
    }
    return self;
}


@end
