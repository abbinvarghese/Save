//
//  CoreDataHelper.h
//  Save
//
//  Created by Abbin on 18/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface CoreDataHelper : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (CoreDataHelper *)sharedCLCoreDataHelper;

-(void)saveEntriesWithAmount: (double)amount type :(NSString*)type notes:(NSString*)note date:(NSDate*)date image:(UIImage*)image isIncome:(BOOL) isIncome;

@end
