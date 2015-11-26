//
//  EntryObject.h
//  Save
//
//  Created by Abbin on 26/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EntryObject : NSObject

@property(nonatomic,assign) NSInteger amount;
@property(nonatomic,strong) UIImage *attachment;
@property(nonatomic,strong) NSDate *date;
@property(nonatomic,assign) BOOL isIncome;
@property(nonatomic,strong) NSString *notes;
@property(nonatomic,strong) NSString *type;

@end
