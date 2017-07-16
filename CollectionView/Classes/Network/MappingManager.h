//
//  MappingManager.h
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainEntity;

/**
 Simple serializer from json and to json. Can be upgraded to save objects to CoreData if needed
 */
@interface MappingManager : NSObject

- (NSOperation *)mappingOperationWithData:(NSData *)data
                                  success:(void (^)(NSArray *))success
                                  failure:(void (^)(NSError *error))failure;

- (NSOperation *)serializationOperationWithObjects:(NSArray <MainEntity *>*)objects
                                           success:(void (^)(NSData *))success
                                           failure:(void (^)(NSError *error))failure;

@end
