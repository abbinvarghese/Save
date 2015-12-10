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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height-20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell" forIndexPath:indexPath];
    cell.obj = self.obj;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
