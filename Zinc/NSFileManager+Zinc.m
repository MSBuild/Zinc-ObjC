//
//  NSFileManager+Zinc.m
//  Zinc-iOS
//
//  Created by Andy Mroczkowski on 12/5/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "NSFileManager+Zinc.h"
#import "NSData+Zinc.h"

@implementation NSFileManager (Zinc)

+ (NSFileManager *) zinc_newFileManager
{
    return [[[NSFileManager alloc] init] autorelease];
}

- (BOOL) zinc_directoryExistsAtPath:(NSString*)path
{
    BOOL isDir;
    BOOL result = [self fileExistsAtPath:path isDirectory:&isDir];
    return result && isDir;
}

- (BOOL) zinc_directoryExistsAtURL:(NSURL*)url
{
    return [self zinc_directoryExistsAtPath:[url path]];
}

- (BOOL) zinc_createDirectoryIfNeededAtPath:(NSString*)path error:(NSError**)outError
{
    if (![self zinc_directoryExistsAtPath:path]) {
        if (![self createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:outError]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) zinc_createDirectoryIfNeededAtURL:(NSURL*)url error:(NSError**)outError
{
    return [self zinc_createDirectoryIfNeededAtPath:[url path] error:outError];
}

#define SHA_READ_BUFFER_SIZE (4096)

- (NSString*) zinc_sha1ForPath:(NSString*)path
{
    if (![self fileExistsAtPath:path]) {
        return nil;
    }
 
    NSData* data = [[NSData alloc] initWithContentsOfFile:path];
    return [data zinc_sha1];
}

@end
