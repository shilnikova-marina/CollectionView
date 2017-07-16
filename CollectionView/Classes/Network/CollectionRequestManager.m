//
//  CollectionRequestManager.m
//  CollectionView
//
//  Created by Marina Shilnikova on 11.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "CollectionRequestManager.h"
#import "NetworkManager.h"
#import "APIResourcePaths.h"

static const NSString *kResult = @"result";
static const NSString *kObject = @"object";
static const NSString *kIndex = @"index";

@interface CollectionRequestManager ()

@property (nonatomic, strong) NetworkManager *networkManager;

@end

@implementation CollectionRequestManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.networkManager = [[NetworkManager alloc] init];
    }
    return self;
}

- (void)requestAllItems:(void (^)(NSArray *result))success
                failure:(void (^)(NSError *error))failure {
    [self.networkManager performGetRequestWithPath:[APIResourcePaths getPath]
                                        parameters:nil
                                           success:^(NSDictionary *result) {
                                               success(result[kResult]);
                                           }
                                           failure:failure];
}

- (void)deleteEntity:(MainEntity *)entity
             success:(void (^)())success
             failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{kObject : entity};
    [self.networkManager performDeleteRequestWithPath:[APIResourcePaths deletePath]
                                           parameters:parameters
                                              success:^(NSDictionary *result) {
                                                  success();
                                              }
                                              failure:failure];
}

- (void)addEntity:(MainEntity *)entity
          success:(void (^)())success
          failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{kObject : entity};
    [self.networkManager performPostRequestWithPath:[APIResourcePaths addPath]
                                         parameters:parameters
                                            success:^(NSDictionary *result) {
                                                success();
                                            }
                                            failure:failure];
}

- (void)moveEntity:(MainEntity *)entity
        toPosition:(NSUInteger)position
           success:(void (^)())success
           failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{kObject : entity, kIndex: @(position)};
    [self.networkManager performPutRequestWithPath:[APIResourcePaths movePath]
                                        parameters:parameters
                                           success:^(NSDictionary *result) {
                                               success();
                                           }
                                           failure:failure];
}

@end
