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
    
    // FINAL SAVE
    NSError *error = nil;
    // Save the object to persistent store
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}

//-(NSArray*)getAllEntries{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription
//                                   entityForName:@"Entries" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    NSError *error = nil;
//    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    
//    
//}

-(NSMutableArray*)collectFinalBalanceDate{
    NSMutableArray *dateVals = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSDate *date = [[NSUserDefaults standardUserDefaults]objectForKey:@"monthlyLimitDay"];
    
    [dateVals addObject:[NSString stringWithFormat:@"%ld",(long)date.day]];
    
    for (NSManagedObject *info in fetchedObjects) {
        NSDate *date = [info valueForKey:@"date"];
        [dateVals addObject:[NSString stringWithFormat:@"%ld",(long)date.day]];
    }
    return dateVals;
}

-(NSMutableArray*)collectFinalBalanceAmount{
    NSMutableArray *dateVals = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    [dateVals addObject:[[BarChartDataEntry alloc]initWithValue:[[[NSUserDefaults standardUserDefaults]objectForKey:@"monthlyLimit"] doubleValue] xIndex:0]];
    
    for (int i = 0; i < fetchedObjects.count; i++) {
        BarChartDataEntry *entry = [dateVals objectAtIndex:i];
        double amt;
        if ([[[fetchedObjects objectAtIndex:i] valueForKey:@"isIncome"]boolValue]) {
            amt = entry.value+[[[fetchedObjects objectAtIndex:i] valueForKey:@"amount"] doubleValue];
        }
        else{
            amt = entry.value-[[[fetchedObjects objectAtIndex:i] valueForKey:@"amount"] doubleValue];
        }
        [dateVals addObject:[[BarChartDataEntry alloc] initWithValue:amt xIndex:i+1]];
    }
    
    return dateVals;
}




@end
