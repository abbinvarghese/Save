//
//  CoreDataHelper.m
//  Save
//
//  Created by Abbin on 18/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "CoreDataHelper.h"
#import "NSDate+SDate.h"

@import Charts;

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

-(BOOL)didSaveMonthlyEntryInBackGround{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"monthlyAdd == 1"]];
    NSError *error = nil;
    NSArray *fetchedObject = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObject.count>0) {
        Entries *entry = [fetchedObject objectAtIndex:fetchedObject.count-1];
        
        if ([entry.monthDate doubleValue] > [[NSString stringWithFormat:@"%ld%ld",(long)[NSDate date].year,(long)[NSDate date].month] doubleValue]) {
            Entries *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Entries" inManagedObjectContext:self.managedObjectContext];
            newDevice.amount = [NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults] valueForKey:@"monthlyLimit"] doubleValue]];
            newDevice.monthlyAdd = [NSNumber numberWithBool:YES];
            newDevice.monthDate = [NSNumber numberWithDouble:[[NSString stringWithFormat:@"%ld%ld",(long)[NSDate date].year,(long)[NSDate date].month] doubleValue]];
            newDevice.date = [NSDate date];
            
            // FINAL SAVE
            NSError *error = nil;
            // Save the object to persistent store
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            return YES;
        }
    }
    return NO;
}

-(void)saveMonthlyEntryWithAmount:(double)amount{
    Entries *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Entries" inManagedObjectContext:self.managedObjectContext];
    newDevice.amount = [NSNumber numberWithDouble:amount];
    newDevice.monthlyAdd = [NSNumber numberWithBool:YES];
    newDevice.monthDate = [NSNumber numberWithDouble:[[NSString stringWithFormat:@"%ld%ld",(long)[NSDate date].year,(long)[NSDate date].month] doubleValue]];
    newDevice.date = [NSDate date];
    
    // FINAL SAVE
    NSError *error = nil;
    // Save the object to persistent store
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

-(void)saveEntriesWithAmount:(double)amount type:(NSString *)type notes:(NSString *)note date:(NSDate *)date image:(UIImage *)image isIncome:(BOOL)isIncome{
    // Create a new managed object
    Entries *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Entries" inManagedObjectContext:self.managedObjectContext];
    newDevice.amount = [NSNumber numberWithDouble:amount];
    newDevice.type = type;
    newDevice.date = date;
    newDevice.monthDate = [NSNumber numberWithDouble:[[NSString stringWithFormat:@"%ld%ld",(long)date.year,(long)date.month] doubleValue]];
    newDevice.monthlyAdd = [NSNumber numberWithBool:NO];
    newDevice.isIncome = [NSNumber numberWithBool:isIncome];
    if (note.length>0) {
        newDevice.note = note;
    }
    if (image) {
        NSData *imageData = UIImagePNGRepresentation(image);
        newDevice.attachment = imageData;
    }
    
    // FINAL SAVE
    NSError *error = nil;
    // Save the object to persistent store
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}

-(void)deleteObject:(Entries*)object{
    [self.managedObjectContext deleteObject:object];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
    }
}

-(NSArray*)getAllEntries{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"monthlyAdd == 0"]];
    NSError *error = nil;
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

-(NSMutableArray*)collectFinalBalanceWithMonthDate:(NSString*)monthDate{
    NSMutableArray *dateVals = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (int i = 0; i < fetchedObjects.count; i++) {
        Entries *entry = [fetchedObjects objectAtIndex:i];
        if ([entry.monthDate isEqualToNumber:[NSNumber numberWithDouble:[monthDate doubleValue]]]) {
            [dateVals addObject:[NSString stringWithFormat:@"%ld",entry.date.day]];
        }
    }
    return dateVals;
}

-(NSMutableArray*)collectFinalBalanceAmountWithMonthDate:(double)monthDate{
    NSMutableArray *dateVals = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    double amt = 0;
    for (int i = 0; i < fetchedObjects.count; i++) {
        Entries *entry = [fetchedObjects objectAtIndex:i];
        
        if ([entry.monthlyAdd boolValue] || [entry.isIncome boolValue]){
            amt = amt + [entry.amount doubleValue];
            if ([entry.monthDate isEqualToNumber:[NSNumber numberWithDouble:monthDate]]) {
                [dateVals addObject:[[BarChartDataEntry alloc] initWithValue:amt xIndex:i]];
            }
        }
        else{
            amt = amt - [entry.amount doubleValue];
            if ([entry.monthDate isEqualToNumber:[NSNumber numberWithDouble:monthDate]]) {
                [dateVals addObject:[[BarChartDataEntry alloc] initWithValue:amt xIndex:i]];
            }
        }
    }
    
    return dateVals;
}




@end
