//
//  ZincOperation.h
//  Zinc-ObjC
//
//  Created by Andy Mroczkowski on 7/27/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import <Foundation/Foundation.h>

// 0.5 - the same as NSOperation default
extern double const kZincOperationInitialDefaultThreadPriority;

@interface ZincOperation : NSOperation

+ (void) setDefaultThreadPriority:(double)defaultThreadPriority;
+ (double) defaultThreadPriority;

/**
 @discussion NOT Key-Value observable
 */
- (long long) currentProgressValue;

/**
 @discussion NOT Key-Value observable
 */
- (long long) maxProgressValue;

/**
 @discussion NOT Key-Value observable
 */
- (double) progress;

@end
