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
    
    // Register cell classes
    [self.collectionView registerClass:[IntroCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[IntroCollectionViewCellTwo class] forCellWithReuseIdentifier:reuseIdentifierTwo];
    [self.collectionView registerClass:[IntroCollectionViewCellThree class] forCellWithReuseIdentifier:reuseIdentifierThree];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark - UICollectionViewDataSource

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
        cellthree.delegate = self;
        return cellthree;
    }
    else{
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size;
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark - IntroCellDelegates

- (void)introCelldidtapNext:(IntroCollectionViewCell *)cell{
    NSIndexPath *index = [NSIndexPath indexPathForRow:cell.cellIndexPath.row+1 inSection:cell.cellIndexPath.section];
    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)introCelldidtapNextTwo:(IntroCollectionViewCellTwo *)cell{
    NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)introCelldidtapNextThree:(IntroCollectionViewCellThree *)cell{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
