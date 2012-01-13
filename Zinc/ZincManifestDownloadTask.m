//
//  ZincManifestUpdateOperation.m
//  Zinc-iOS
//
//  Created by Andy Mroczkowski on 1/10/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import "ZincManifestDownloadTask.h"
#import "ZincBundle.h"
#import "ZincSource.h"
#import "ZincRepo.h"
#import "ZincRepo+Private.h"
#import "ZincManifest.h"
#import "ZincResource.h"
#import "AFHTTPRequestOperation.h"
#import "NSData+Zinc.h"
#import "ZincEvent.h"
#import "KSJSON.h"

@implementation ZincManifestDownloadTask

- (id) initWithRepo:(ZincRepo*)repo resourceDescriptor:(NSURL*)resource input:(id)input
{
    self = [super initWithRepo:repo resourceDescriptor:resource input:input];
    if (self) {
        self.title = NSLocalizedString(@"Updating Manifest", @"ZincManifestDownloadTask");
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (NSString*) bundleId
{
    return [self.resource zincBundleId];
}

- (ZincVersion) version
{
    return [self.resource zincBundleVersion];
}

- (void) main
{
    NSError* error = nil;
    NSFileManager* fm = [[[NSFileManager alloc] init] autorelease];
    
    NSString* catalogId = [ZincBundle catalogIdFromBundleId:self.bundleId];
    NSString* bundleName = [ZincBundle bundleNameFromBundleId:self.bundleId];
    ZincSource* source = [[self.repo sourcesForCatalogId:catalogId] lastObject]; // TODO: fix lastObject
    if (source == nil) {
        ZINC_DEBUG_LOG(@"source is nil");
        // TODO: better error
        return;
    }
    
    NSURLRequest* request = [source urlRequestForBundleName:bundleName version:self.version];
    if (request == nil) {
        // TODO: better error
        NSAssert(0, @"request is nil");
        return;
    }
    
    AFHTTPRequestOperation* requestOp = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    [requestOp setAcceptableStatusCodes:[NSIndexSet indexSetWithIndex:200]];
    [self addOperation:requestOp];
    [requestOp waitUntilFinished];
    if (!requestOp.hasAcceptableStatusCode) {
        [self addEvent:[ZincErrorEvent eventWithError:requestOp.error source:self]];
        return;
    }
    
    NSData* uncompressed = [requestOp.responseData zinc_gzipInflate];
    if (uncompressed == nil) {
        // TODO: set error
        NSAssert(NO, @"gunzip failed");
        return;
    }
    
    NSString* jsonString = [[[NSString alloc] initWithData:uncompressed encoding:NSUTF8StringEncoding] autorelease];
    id json = [KSJSON deserializeString:jsonString error:&error];
    if (json == nil) {
        [self addEvent:[ZincErrorEvent eventWithError:error source:self]];
        return;
    }
    
    ZincManifest* manifest = [[[ZincManifest alloc] initWithDictionary:json] autorelease];
    NSData* data = [[manifest jsonRepresentation:&error] dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) {
        [self addEvent:[ZincErrorEvent eventWithError:error source:self]];
        return;
    }
    
    NSString* path = [self.repo pathForManifestWithBundleId:self.bundleId version:manifest.version];
    
    // try remove existing. it shouldn't exist, but being defensive.
    [fm removeItemAtPath:path error:NULL];
    
    if (![data zinc_writeToFile:path atomically:YES createDirectories:YES skipBackup:YES error:&error]) {
        [self addEvent:[ZincErrorEvent eventWithError:error source:self]];
        return;
    }

    [self.repo addManifest:manifest forBundleId:self.bundleId];
    
    self.finishedSuccessfully = YES;
}
@end
