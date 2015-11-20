//
//  IntroCollectionViewController.h
//  Save
//
//  Created by Abbin on 19/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroCollectionViewCell.h"
#import "IntroCollectionViewCellTwo.h"
#import "IntroCollectionViewCellThree.h"

@interface IntroCollectionViewController : UICollectionViewController<IntroCellDelegate,IntroCellTwoDelegate,IntroCellThreeDelegate>

@end
