//
//  IntroCollectionViewController.m
//  Save
//
//  Created by Abbin on 19/11/15.
//  Copyright © 2015 Abbin. All rights reserved.
//

#import "IntroCollectionViewController.h"

@interface IntroCollectionViewController ()

@end

@implementation IntroCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseIdentifierTwo = @"CellTwo";
static NSString * const reuseIdentifierThree = @"CellThree";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[IntroCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[IntroCollectionViewCellTwo class] forCellWithReuseIdentifier:reuseIdentifierTwo];
    [self.collectionView registerClass:[IntroCollectionViewCellThree class] forCellWithReuseIdentifier:reuseIdentifierThree];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1) {
        IntroCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        [cell drawCellWithIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.row == 2){
        IntroCollectionViewCellTwo *cellTwo = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierTwo forIndexPath:indexPath];
        cellTwo.delegate = self;
        return cellTwo;
    }
    else if (indexPath.row == 3){
        IntroCollectionViewCellThree *cellthree = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierThree forIndexPath:indexPath];

        return cellthree;
    }
    else{
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size;
}

-(void)introCelldidtapNext:(IntroCollectionViewCell *)cell{
    NSIndexPath *index = [NSIndexPath indexPathForRow:cell.cellIndexPath.row+1 inSection:cell.cellIndexPath.section];
    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

-(void)introCelldidtapNextTwo:(IntroCollectionViewCellTwo *)cell{
    NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
