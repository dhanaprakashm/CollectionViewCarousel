//
//  BlurQueue.m
//  CollectionViewCarousel
//
//  Created by dmuddineti on 11/29/14.
//  Copyright (c) 2014 dmuddineti. All rights reserved.
//

#import "BlurQueue.h"

@interface BlurQueue ()

@property (nonatomic, assign) NSUInteger queueSize;
@property (nonatomic, strong) NSArray *queue;
@property (atomic, assign) NSUInteger currentIndex;

@end

@implementation BlurQueue

- (instancetype)initWithQueueSize:(NSUInteger)queueSize
{
    self = [super init];
    if (self) {
        self.queueSize = queueSize;
        [self initializeQueue];
    }
    return self;
}

- (void)initializeQueue
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<self.queueSize; i++) {
        array[i] = @(i+1);
    }
    self.queue = [array copy];
}

- (void)applyBlurEffectToView:(UILabel *)label
{
    NSString *nextBlurOberver = [self nextBlurObserver];
//    NSLog(@"%s, applying %@ BlurObserver to %@", __PRETTY_FUNCTION__, nextBlurOberver, label.text);
}

- (NSString *)nextBlurObserver
{
    if(self.currentIndex == ([self.queue count] - 1)) {
        self.currentIndex = 0;
    } else {
        self.currentIndex++;
    }
    
    return self.queue[self.currentIndex];
}

@end
