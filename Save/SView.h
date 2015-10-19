//
//  SView.h
//  Save
//
//  Created by Abbin on 19/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>

@interface SView : UIView<POPAnimationDelegate>

@property(nonatomic,strong)POPBasicAnimation *raiseAnimation;
@property(nonatomic,strong)POPBasicAnimation *lowerAnimation;
@end
