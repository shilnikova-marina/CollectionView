//
//  CollectionRequestManager.h
//  CollectionView
//
//  Created by Marina Shilnikova on 11.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainEntity;

/**
 Request manager for current fake API
 */
@interface CollectionRequestManager : NSObject

- (void)requestAllItems:(void (^)(NSArray *result))success
                failure:(void (^)(NSError *error))failure;

- (void)deleteEntity:(MainEntity *)entity
             success:(void (^)())success
             failure:(void (^)(NSError *error))failure;

- (void)addEntity:(MainEntity *)entity
          success:(void (^)())success
          failure:(void (^)(NSError *error))failure;

- (void)moveEntity:(MainEntity *)entity
        toPosition:(NSUInteger)position
           success:(void (^)())success
           failure:(void (^)(NSError *error))failure;

@end
