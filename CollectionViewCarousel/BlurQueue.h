//
//  BlurQueue.h
//  CollectionViewCarousel
//
//  Created by dmuddineti on 11/29/14.
//  Copyright (c) 2014 dmuddineti. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface BlurQueue : NSObject
- (instancetype)initWithQueueSize:(NSUInteger)queueSize;
- (void)applyBlurEffectToView:(UILabel *)label;
@end
