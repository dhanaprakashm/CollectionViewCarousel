//
//  CollectionViewCarouselDataSource.h
//  CollectionViewCarousel
//
//  Created by dmuddineti on 11/28/14.
//  Copyright (c) 2014 dmuddineti. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol CollectionViewCarouselDelegate <NSObject>
- (void)collectionView:(UICollectionView *)collectionView didDisplayCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)applyBlurEffectTo:(UILabel *)label;
@end

@interface CollectionViewCarouselDataSource : NSObject<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSArray *data;
@property (nonatomic, weak) id<CollectionViewCarouselDelegate> deleate;

- (instancetype)initWithCollection:(UICollectionView *)collectionView;
- (NSIndexPath *)startupIndexPath;
- (NSIndexPath *)currentIndexPath;
- (NSIndexPath *)nextIndexPath;
- (NSIndexPath *)nextIndexPathForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)previousIndexPathForIndexPath:(NSIndexPath *)indexPath;

@end