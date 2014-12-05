//
//  UIScreen+ApplicationBounds.m
//  MobileShopper
//
//  Created by Muddineti, Dhana (NonEmp) on 8/20/14.
//
//

#import "UIScreen+ApplicationBounds.h"

@implementation UIScreen (ApplicationBounds)

+ (CGRect)applicationBounds
{
    CGRect applicationBounds;
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)]) {
        //iOS8 and later
        applicationBounds = [[UIScreen mainScreen] bounds];
    } else {
        //iOS7 and below
        applicationBounds = [[UIScreen mainScreen] bounds];
        
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            applicationBounds = CGRectMake(0, 0, CGRectGetHeight(applicationBounds), CGRectGetWidth(applicationBounds));
        }
    }
    
    return applicationBounds;
}

- (CGRect)applicationBoundsWithOrientationAwareness
{
    CGRect applicationBounds;
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)]) {
        //iOS8 and later
        applicationBounds = [[UIScreen mainScreen] bounds];
        
        
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            applicationBounds = CGRectMake(0, 0, CGRectGetHeight(applicationBounds), CGRectGetWidth(applicationBounds));
        }
    } else {
        //iOS7 and below
        applicationBounds = [[UIScreen mainScreen] bounds];
    }
    
    return applicationBounds;
}

@end
