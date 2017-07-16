//
//  MappingManager.m
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "MappingManager.h"
#import "MainEntity.h"

static const NSString* kItems = @"items";

@implementation MappingManager

- (NSOperation *)mappingOperationWithData:(NSData *)data
                                  success:(void (^)(NSArray *))success
                                  failure:(void (^)(NSError *error))failure {
    return [NSBlockOperation blockOperationWithBlock:^{
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error != nil) {
            failure(error);
            return;
        }
        NSMutableArray *mappedObjects = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in result[kItems]) {
            [mappedObjects addObject:[[MainEntity alloc] initWithDictionary:dictionary]];
        }
        success(mappedObjects);
    }];
}

- (NSOperation *)serializationOperationWithObjects:(NSArray <MainEntity *>*)objects
                                           success:(void (^)(NSData *))success
                                           failure:(void (^)(NSError *error))failure {
    return [NSBlockOperation blockOperationWithBlock:^{
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (MainEntity *object in objects) {
            [result addObject:[object jsonRepresentation]];
        }
        NSDictionary *jsonDictionary = @{kItems : result};
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
        if (error == nil) {
            success(data);
        } else {
            failure(error);
        }
    }];
}



@end
