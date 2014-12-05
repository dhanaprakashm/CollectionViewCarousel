//
//  ViewController.m
//  CollectionViewCarousel
//
//  Created by dmuddineti on 11/28/14.
//  Copyright (c) 2014 dmuddineti. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCarouselDataSource.h"
#import "BlurQueue.h"
#import "CollectionViewCarouselCell.h"
#import "UIScreen+ApplicationBounds.h"

@interface ViewController ()<CollectionViewCarouselDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) CollectionViewCarouselDataSource *dataSource;
@property (nonatomic, strong) NSTimer *rotator;
@property (nonatomic, strong) BlurQueue *blurQueue;
@property (nonatomic, weak) UICollectionViewCell *currentCell;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
    [self setupPageControl];
    [self setupPromoTimer];
    [self setupBlurEffect];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.collectionView scrollToItemAtIndexPath:[self.dataSource startupIndexPath]
    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeTimer];
}

- (void)setupCollectionView
{
    self.dataSource = [[CollectionViewCarouselDataSource alloc] initWithCollection:self.collectionView];
//    self.dataSource.data = @[@"1", @"2"];
    self.dataSource.data = @[@"Ocean.jpeg", @"City.jpeg"];
    
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self.dataSource;
    self.dataSource.deleate = self;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (void)setupPageControl
{
    NSUInteger numberOfPromos = [self.dataSource.data count];
    
    if (numberOfPromos > 1) {
        self.pageControl.numberOfPages = numberOfPromos;
        self.pageControl.hidden = NO;
    } else {
        self.pageControl.hidden = YES;
    }
}

- (void)setupPromoTimer
{
    NSUInteger numberOfPromos = [self.dataSource.data count];
    
    if (numberOfPromos > 1) {
        self.rotator = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                        target:self
                                                      selector:@selector(moveToNextPromo:)
                                                      userInfo:nil
                                                       repeats:YES];
    } else {
        [self removeTimer];
    }
}

- (void)setupBlurEffect
{
    self.blurQueue = [[BlurQueue alloc] initWithQueueSize:3];
}

- (void)removeTimer
{
    if (self.rotator) {
        [self.rotator invalidate];
        self.rotator = nil;
    }
}

- (void)moveToNextPromo:(NSTimer *)timer
{
    NSIndexPath *nextIndexPath = [self.dataSource nextIndexPath];
    
    if(nextIndexPath) {
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
        
        
        
        if(nextIndexPath.item == [self.collectionView numberOfItemsInSection:0] - 2) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:([self.dataSource.data count] - 2) inSection:0]
                                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                    animated:NO];
            });
        }
//        [self applyBlurEffectForCurrentIndexPath:nextIndexPath];
    }
}

#pragma mark - CollectionViewCarouselDataSource
- (void)collectionView:(UICollectionView *)collectionView didDisplayCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [self updatePageControlForCurrentIndexPath:indexPath];
}

- (void)updatePageControlForCurrentIndexPath:(NSIndexPath *)indexPath
{
    self.pageControl.currentPage = indexPath.item%[self.dataSource.data count];
}

#pragma mark - BlurEffect
- (void)applyBlurEffectForCurrentIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *views = [[NSMutableArray alloc] init];
    UICollectionViewCell *currentCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UICollectionViewCell *nextCell = [self.collectionView cellForItemAtIndexPath:[self.dataSource nextIndexPathForIndexPath:indexPath]];
    UICollectionViewCell *previousCell = [self.collectionView cellForItemAtIndexPath:[self.dataSource previousIndexPathForIndexPath:indexPath]];
    
    if(currentCell) {
        [views addObject:currentCell];
    } else {
        NSLog(@"Current Cell is nil at indexPath %@", indexPath);
    }
    
    if(nextCell) {
        [views addObject:nextCell];
    } else {
        NSLog(@"Next Cell is nil");
    }

    if(previousCell) {
        [views addObject:previousCell];
    } else {
        NSLog(@"Previous Cell is nil");
    }
    
    [self applyBlurEffectToViews:views];
}

- (void)applyBlurEffectToViews:(NSArray *)views
{
    for (CollectionViewCarouselCell *cell in views) {
        NSLog(@"Label: %@", cell.label);
    }
}

- (void)applyBlurEffectToView:(UILabel *)label
{
    [self.blurQueue applyBlurEffectToView:label];
}

- (void)applyBlurEffectTo:(UILabel *)label
{
    [self.blurQueue applyBlurEffectToView:label];
}

#pragma mark - Rotations
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self animatePromoRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    [self.collectionView reloadData];
}

- (void)animatePromoRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    int currentPage = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    float width = CGRectGetHeight([UIScreen applicationBounds]);
    
    [UIView animateWithDuration:duration animations:^{
        [self.collectionView setContentOffset:CGPointMake(width * currentPage, 0.0) animated:NO];
        [[self.collectionView collectionViewLayout] invalidateLayout];
    }];
}


//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath
//                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
//                                        animated:NO];
//}

@end
