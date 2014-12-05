//
//  CollectionViewCarouselDataSource.m
//  CollectionViewCarousel
//
//  Created by dmuddineti on 11/28/14.
//  Copyright (c) 2014 dmuddineti. All rights reserved.
//

#import "CollectionViewCarouselDataSource.h"
#import "CollectionViewCarouselCell.h"

#define kNumberOfRotations 4

@interface CollectionViewCarouselDataSource ()
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation CollectionViewCarouselDataSource

- (instancetype)initWithCollection:(UICollectionView *)collectionView
{
    self = [super init];
    if (self) {
        _collectionView = collectionView;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger numberOfPromos = [self.data count];
    
    if(numberOfPromos > 1) {
        return [self.data count] * kNumberOfRotations;
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s - %@", __PRETTY_FUNCTION__, indexPath);
    
    CollectionViewCarouselCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSUInteger index = indexPath.item%([self.data count]);
    
//    cell.label.text = [NSString stringWithFormat:@"%@ - %lu", self.data[index], (unsigned long)indexPath.item];
    cell.imageView.image = [UIImage imageNamed:self.data[index]];
//    cell.backgroundColor = [UIColor lightGrayColor];
    
//    UIImage *image = [UIImage imageNamed:self.data[index]];
//    
//    if ([UIScreen mainScreen].scale == 1.0) {
//        cell.imageView.image = [UIImage imageWithCGImage:[image CGImage] scale:2.0 orientation:UIImageOrientationUp];
//    } else {
//        cell.imageView.image = image;
//    }
    
    if(indexPath.item%2 == 0) {
        cell.backgroundColor = [UIColor yellowColor];
    } else {
        cell.backgroundColor = [UIColor orangeColor];
    }
    
    [self.deleate applyBlurEffectTo:cell.label];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.deleate) {
        [self.deleate collectionView:self.collectionView
                      didDisplayCell:nil
                         atIndexPath:[self currentIndexPath]];
    }
}

#pragma mark - Util
- (NSIndexPath *)startupIndexPath
{
    if([self.data count] > 1) {
        NSUInteger index = [self.data count] * (kNumberOfRotations/2);
        return [NSIndexPath indexPathForItem:index inSection:0];
    } else {
        return [NSIndexPath indexPathForItem:0 inSection:0];
    }
}

- (NSIndexPath *)currentIndexPath
{
    NSArray *currentIndexPaths = [self.collectionView indexPathsForVisibleItems];
    
    if([currentIndexPaths count] == 1) {
        return currentIndexPaths[0];
    } else {
        return nil;
    }
}

- (NSIndexPath *)nextIndexPath
{
    return [self nextIndexPathForIndexPath:[self currentIndexPath]];
}

- (NSIndexPath *)nextIndexPathForIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *nextIndexPath;
    
    if(indexPath) {
        if(indexPath.item == [self.collectionView numberOfItemsInSection:0]-1) {
            nextIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        } else {
            nextIndexPath = [NSIndexPath indexPathForItem:(indexPath.item+1) inSection:0];
        }
    }
    
    return nextIndexPath;
}

- (NSIndexPath *)previousIndexPathForIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *previousIndexPath;
    
    if(indexPath) {
        if(indexPath.item == 0) {
            previousIndexPath = [NSIndexPath indexPathForItem:([self.collectionView numberOfItemsInSection:0]-1) inSection:0];
        } else {
            previousIndexPath = [NSIndexPath indexPathForItem:(indexPath.item-1) inSection:0];
        }
    }
    
    return previousIndexPath;
}

//- (void)applyBlurForCurrentIndexPath:(NSIndexPath *)currentIndexPath
//{
//    NSIndexPath *nextIndexPath = [self nextIndexPathForIndexPath:currentIndexPath];
//    NSIndexPath *previousIndexPath = [self previousIndexPathForIndexPath:currentIndexPath];
//}

@end
