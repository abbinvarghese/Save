//
//  CoreDataHelper.h
//  Save
//
//  Created by Abbin on 18/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Entries.h"
#import "Entries+CoreDataProperties.h"

@interface CoreDataHelper : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (CoreDataHelper *)sharedCLCoreDataHelper;

-(void)saveMonthlyEntryWithAmount:(double)amount;
-(void)saveEntriesWithAmount: (double)amount type :(NSString*)type notes:(NSString*)note date:(NSDate*)date image:(UIImage*)image isIncome:(BOOL) isIncome;
-(NSMutableArray*)collectFinalBalanceWithMonthDate:(NSString*)monthDate;
-(NSMutableArray*)collectFinalBalanceAmountWithMonthDate:(double)monthDate;
-(NSArray*)getAllEntries;
-(void)deleteObject:(Entries*)object;
-(BOOL)didSaveMonthlyEntryInBackGround;
-(NSString*)currencyFormString:(NSString*)string;

@end
