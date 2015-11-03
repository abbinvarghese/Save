//
//  SButton.h
//  Save
//
//  Created by Abbin on 02/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

@class SButton;

#import <UIKit/UIKit.h>

@protocol SButtonDelegate <NSObject>

-(void)didTapSButton:(SButton*)button;

@end

@interface SButton : UIButton

@property (nonatomic,strong) id <SButtonDelegate> delegate;

@end
