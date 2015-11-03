//
//  SLabel.h
//  Save
//
//  Created by Abbin on 30/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLabel : UILabel

@property(nonatomic,assign) BOOL shouldTouch;
@property(nonatomic,assign) BOOL didFinishTouches;

-(void)drawRect:(CGRect)rect withShadow:(BOOL)shadow;

@end
