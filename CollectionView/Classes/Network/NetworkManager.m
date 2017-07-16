//
//  NetworkManager.m
//  CollectionView
//
//  Created by Marina Shilnikova on 11.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "NetworkManager.h"
#import <UIKit/UIKit.h>
#import "APIResourcePaths.h"
#import "MainEntity.h"
#import "MappingManager.h"

static const CGFloat networkDelay = 0.1;

@implementation NetworkManager

#pragma mark - shared queue

/**
 Common operation queue for future requests
 */
+ (NSOperationQueue *)operationQueue {
    static NSOperationQueue *operationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 1;
    });
    
    return operationQueue;
}

#pragma mark - public

- (void)performGetRequestWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(NSDictionary *))success
                          failure:(void (^)(NSError *error))failure {
    [self performFakeRequestWithPath:path parameters:parameters success:success failure:failure];
}

- (void)performPostRequestWithPath:(NSString *)path
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(NSDictionary *))success
                           failure:(void (^)(NSError *error))failure {
    [self performFakeRequestWithPath:path parameters:parameters success:success failure:failure];
}

- (void)performPutRequestWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(NSDictionary *))success
                          failure:(void (^)(NSError *error))failure {
    [self performFakeRequestWithPath:path parameters:parameters success:success failure:failure];
}

- (void)performDeleteRequestWithPath:(NSString *)path
                          parameters:(NSDictionary *)parameters
                             success:(void (^)(NSDictionary *))success
                             failure:(void (^)(NSError *error))failure {
    [self performFakeRequestWithPath:path parameters:parameters success:success failure:failure];
}

#pragma mark - private

/**
 Perform fake request from saved json. Copy json to disc in the first launch and modifies it for next actions
 */
- (void)performFakeRequestWithPath:(NSString *)path
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(NSDictionary *))success
                           failure:(void (^)(NSError *error))failure {
    dispatch_after
    (dispatch_time(DISPATCH_TIME_NOW, (int64_t)(networkDelay * NSEC_PER_SEC)),
     [NetworkManager operationQueue].underlyingQueue,^{
         NSArray *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
         NSString *filePath = [[cachesDirectory objectAtIndex:0] stringByAppendingPathComponent:@"json"];
         if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
             NSString *initialFilePath = [[NSBundle mainBundle] pathForResource:@"items" ofType:@"json"];
             [[NSFileManager defaultManager] copyItemAtPath:initialFilePath toPath:filePath error:nil];
         }
         MappingManager *mappingManager = [[MappingManager alloc] init];
         NSOperation *mappingOperation =
         [mappingManager mappingOperationWithData:[NSData dataWithContentsOfFile:filePath]
                                          success:^(NSArray *result) {
                                              NSMutableArray *currentObjects = [result mutableCopy];
                                              if ([path isEqualToString:[APIResourcePaths addPath]]) {
                                                  [currentObjects addObject:[parameters objectForKey:@"object"]];
                                              } else if ([path isEqualToString:[APIResourcePaths deletePath]]) {
                                                  [currentObjects removeObject:[parameters objectForKey:@"object"]];
                                              } else if ([path isEqualToString:[APIResourcePaths movePath]]) {
                                                  MainEntity *object = [parameters objectForKey:@"object"];
                                                  [currentObjects removeObject:object];
                                                  [currentObjects insertObject:object atIndex:[[parameters objectForKey:@"index"] intValue]];
                                              }
                                              NSOperation *serializationOperation =
                                              [mappingManager serializationOperationWithObjects:currentObjects
                                                                                        success:^(NSData *serializedData) {
                                                                                            [serializedData writeToFile:filePath atomically:YES];
                                                                                            success(@{@"result": currentObjects});
                                                                                        }
                                                                                        failure:^(NSError *error) {
                                                                                            failure(error);
                                                                                        }];
                                              [[NetworkManager operationQueue] addOperation:serializationOperation];
                                              
                                          } failure:^(NSError *error) {
                                              failure(error);
                                          }];
         [[NetworkManager operationQueue] addOperation:mappingOperation];
     });
}

@end
