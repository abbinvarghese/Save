//
//  NSDate+SDate.h
//  Save
//
//  Created by Abbin on 26/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SDate)

-(NSInteger)day;
-(NSInteger)month;
-(NSInteger)year;
-(NSString*)monthName;
-(NSString*)shortDate;

@end
