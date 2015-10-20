//
//  SView.h
//  Save
//
//  Created by Abbin on 19/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SView : UIView

@property(nonatomic,assign)BOOL touchesDidEnd;
@property(nonatomic,assign)BOOL shouldTouch;
@property(nonatomic,assign) int viewTag;


-(void)touchesBegan:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
-(void)touchesEnded:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;



@end
