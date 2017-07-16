//
//  NetworkManager.h
//  CollectionView
//
//  Created by Marina Shilnikova on 11.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Network manager with templates for future requests. Supports custom network delay for testing
 */
@interface NetworkManager : NSObject

- (void)performGetRequestWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(NSDictionary *))success
                          failure:(void (^)(NSError *error))failure;

- (void)performPostRequestWithPath:(NSString *)path
                          parameters:(NSDictionary *)parameters
                             success:(void (^)(NSDictionary *))success
                             failure:(void (^)(NSError *error))failure;

- (void)performPutRequestWithPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(NSDictionary *))success
                          failure:(void (^)(NSError *error))failure;

- (void)performDeleteRequestWithPath:(NSString *)path
                          parameters:(NSDictionary *)parameters
                             success:(void (^)(NSDictionary *))success
                             failure:(void (^)(NSError *error))failure;

@end
