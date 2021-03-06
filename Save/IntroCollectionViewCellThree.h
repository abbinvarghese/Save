//
//  IntroCollectionViewCellThree.h
//  Save
//
//  Created by Abbin on 20/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//
@class IntroCollectionViewCellThree;

#import <UIKit/UIKit.h>

@protocol IntroCellThreeDelegate <NSObject>

-(void)introCelldidtapNextThree:(IntroCollectionViewCellThree*)cell;

@end


@interface IntroCollectionViewCellThree : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) id<IntroCellThreeDelegate> delegate;

@end
