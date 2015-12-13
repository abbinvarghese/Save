//
//  EntriesDetailTableViewController.m
//  Save
//
//  Created by Abbin on 10/12/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "EntriesDetailTableViewController.h"
#import "DetailTableViewCell.h"

@interface EntriesDetailTableViewController ()

@property (nonatomic,strong) UILabel *refreshLabel;

@end

@implementation EntriesDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DetailTableViewCell"];
    
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


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height-20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell" forIndexPath:indexPath];
    cell.obj = self.obj;
    return cell;
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
