//
//  IntroCollectionViewCellTwo.h
//  Save
//
//  Created by Abbin on 20/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//
@class IntroCollectionViewCellTwo;
#import <UIKit/UIKit.h>
#import "IntroButton.h"
#import "SIntroLabel.h"

@protocol IntroCellTwoDelegate <NSObject>

-(void)introCelldidtapNextTwo:(IntroCollectionViewCellTwo*)cell;

@end

@interface IntroCollectionViewCellTwo : UICollectionViewCell

@property (strong, nonatomic) UILabel *amountLabel;

@property (strong, nonatomic) IBOutlet UIButton *cellNextButton;

@property(nonatomic,strong)NSMutableString *amount;

@property (nonatomic, strong) id<IntroCellTwoDelegate> delegate;

@end
