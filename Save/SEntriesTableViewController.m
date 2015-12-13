//
//  SEntriesTableViewController.m
//  Save
//
//  Created by Abbin on 26/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "SEntriesTableViewController.h"
#import "CoreDataHelper.h"
#import "Entries.h"
#import "Entries+CoreDataProperties.h"
#import "NSDate+SDate.h"
#import "SIntroLabel.h"
#import "EntriesDetailTableViewController.h"

@interface SEntriesTableViewController ()

@property (nonatomic,strong) NSMutableArray *entriesArray;
@property (nonatomic,strong) UILabel *refreshLabel;
@property (strong, nonatomic) UIView *hideView;

@end

@implementation SEntriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hideView = [[UIView alloc]initWithFrame:self.view.frame];
    self.hideView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:self.hideView];
    
    self.entriesArray = [[NSMutableArray alloc]initWithArray:[[CoreDataHelper sharedCLCoreDataHelper]getAllEntries]];
    if (self.entriesArray.count==0) {
        SIntroLabel *msg = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        msg.text = @"no entries. pull down to dismiss";
        msg.center = self.tableView.center;
        msg.alpha = 1;
        [msg setFont:[UIFont fontWithName:@"SFUIDisplay-Ultralight" size:20]];
        [self.tableView addSubview:msg];
    }
    
    self.refreshLabel = [[UILabel alloc]initWithFrame:self.refreshControl.frame];
    [self.refreshLabel setTextAlignment:NSTextAlignmentCenter];
    self.refreshLabel.text = @"pull down to dismiss";
    self.refreshLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:20];
    [self.refreshControl addSubview:self.refreshLabel];
    self.refreshControl.tintColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.hideView.alpha = 0;
    }completion:^(BOOL finished){
        
    }];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark - UITableView Data Sourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.entriesArray .count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SEntriesTableViewControllerCell" forIndexPath:indexPath];
    Entries *obj = [self.entriesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [[CoreDataHelper sharedCLCoreDataHelper] currencyFormString:[obj.amount stringValue]];
    cell.detailTextLabel.text = obj.date.shortDate;
    if ([obj.isIncome boolValue]) {
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:1 blue:0.9 alpha:1];
    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:1 green:0.9 blue:0.9 alpha:1];
    }
    cell.textLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:20];
    cell.detailTextLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:15];
    return cell;
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark - UITableView Delegates


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[CoreDataHelper sharedCLCoreDataHelper]deleteObject:[self.entriesArray objectAtIndex:indexPath.row]];
        [self.entriesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // SHOW MESSAGE SAYING THE IS NO MORE ENTRIES
    if (self.entriesArray.count==0) {
        SIntroLabel *msg = [[SIntroLabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        msg.text = @"no entries. pull down to dismiss";
        msg.center = self.tableView.center;
        msg.alpha = 1;
        [msg setFont:[UIFont fontWithName:@"SFUIDisplay-Ultralight" size:20]];
        [self.tableView addSubview:msg];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EntriesDetailTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"EntriesDetailTableViewController"];
    vc.obj = [self.entriesArray objectAtIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:^(void){
        self.hideView.alpha = 1;
    }];
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark - Pull to Dismiss Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.refreshLabel.center = CGPointMake(self.refreshLabel.center.x,-scrollView.contentOffset.y/2.5);
    float offSetY = scrollView.contentOffset.y;
    CGFloat adjustment = 150.0;
    if (-offSetY>(28+adjustment)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)didPullDown:(UIRefreshControl *)sender {
    [self.refreshControl endRefreshing];
}

@end
