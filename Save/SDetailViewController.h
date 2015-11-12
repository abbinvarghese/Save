//
//  SDetailViewController.h
//  Save
//
//  Created by Abbin on 20/10/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"
#import "SButton.h"

@import MediaPlayer;

@interface SDetailViewController : UIViewController<AKPickerViewDataSource, AKPickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SButtonDelegate,UITextViewDelegate>

@property(nonatomic,assign) BOOL isIncome;

@end
