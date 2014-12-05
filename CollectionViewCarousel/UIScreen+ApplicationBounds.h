//
//  UIScreen+ApplicationBounds.h
//  MobileShopper
//
//  Created by Muddineti, Dhana (NonEmp) on 8/20/14.
//
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface UIScreen (ApplicationBounds)
+ (CGRect)applicationBounds;
- (CGRect)applicationBoundsWithOrientationAwareness;
@end
