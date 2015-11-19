//
//  CoreDataHelper.m
//  Save
//
//  Created by Abbin on 18/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

static CoreDataHelper *coreDataHelper = nil;

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    return self;
}

+ (CoreDataHelper *)sharedCLCoreDataHelper
{
    @synchronized(self)
    {
        if(coreDataHelper == nil)
        {
            coreDataHelper =[[self alloc] init];
        }
    }
    return coreDataHelper;
}

-(void)saveEntriesWithAmount:(double)amount type:(NSString *)type notes:(NSString *)note date:(NSDate *)date image:(UIImage *)image isIncome:(BOOL)isIncome{
    // Create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Entries" inManagedObjectContext:self.managedObjectContext];
    [newDevice setValue:[NSNumber numberWithDouble:amount] forKey:@"amount"];
    [newDevice setValue:type forKey:@"type"];
    [newDevice setValue:date forKey:@"date"];
    [newDevice setValue:[NSNumber numberWithBool:isIncome] forKey:@"isIncome"];
    if (note.length>0) {
        [newDevice setValue:note forKey:@"note"];
    }
    if (image) {
        NSData *imageData = UIImagePNGRepresentation(image);
        [newDevice setValue:imageData forKey:@"attachment"];
    }
    
    
    // GETTING LAST FINAL AMOUNT AND CALCULATING NEW
    newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"FinalBalances" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FinalBalances" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // Results should be in descending order of timeStamp.
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:NULL];
    NSManagedObject *latestEntity = [results objectAtIndex:0];
    double lastAmt = [[latestEntity valueForKey:@"amount"] doubleValue];
    NSNumber *newlastnum;
    if (isIncome) {
        newlastnum = [NSNumber numberWithDouble:lastAmt + amount];
    }
    else{
        newlastnum = [NSNumber numberWithDouble:lastAmt - amount];
    }
    [newDevice setValue:newlastnum forKey:@"amount"];
    
    
    // FINAL SAVE
    NSError *error = nil;
    // Save the object to persistent store
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}




@end
