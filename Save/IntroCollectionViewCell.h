//
//  IntroCollectionViewCell.h
//  Save
//
//  Created by Abbin on 19/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//
@class IntroCollectionViewCell;
#import <UIKit/UIKit.h>
#import "SIntroLabel.h"
#import "IntroButton.h"

@protocol IntroCellDelegate <NSObject>

-(void)introCelldidtapNext:(IntroCollectionViewCell*)cell;

@end

@interface IntroCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@property (nonatomic, strong) UIImageView *cellImageView;

@property (strong, nonatomic) IBOutlet UIButton *cellNextButton;
@property (strong, nonatomic) SIntroLabel *smileLabel;
@property (strong, nonatomic) SIntroLabel *smileLabel2;
@property (strong, nonatomic) SIntroLabel *smileLabel3;
@property (strong, nonatomic) SIntroLabel *smileLabel4;
@property (strong, nonatomic) SIntroLabel *smileLabel5;
@property (strong, nonatomic) SIntroLabel *smileLabel6;

@property (nonatomic, strong) id<IntroCellDelegate> delegate;

-(void)drawCellWithIndexPath:(NSIndexPath*)indexPath;

@end
