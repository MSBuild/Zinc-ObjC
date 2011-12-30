//
//  ZCBundle+Private.h
//  Zinc-iOS
//
//  Created by Andy Mroczkowski on 12/5/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "ZincBundle.h"
#import "ZincRepo.h"

@interface ZincBundle ()

//+ (ZCBundle*) bundleWithURL:(NSURL*)url error:(NSError**)outError;
//+ (ZCBundle*) bundleWithPath:(NSString*)path error:(NSError**)outError;

//+ (ZCBundle*) bundleWithURL:(NSURL*)url version:(ZincVersion)version error:(NSError**)outError;
//+ (ZCBundle*) bundleWithPath:(NSString*)path version:(ZincVersion)version error:(NSError**)outError;

- (id) initWithRepo:(ZincRepo*)fileSystem;

@property (nonatomic, retain) ZincRepo* repo;

@end