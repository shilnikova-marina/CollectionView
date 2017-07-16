//
//  MainEntity.m
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "MainEntity.h"

static NSString * const kUUID = @"uuid";
static NSString * const kImageUrl = @"imageUrlString";

@implementation MainEntity

- (instancetype)initWithDictionary:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.uuid = [json objectForKey:kUUID];
        self.imageUrl = [json objectForKey:kImageUrl];
    }
    NSAssert(self.uuid != nil && self.imageUrl != nil, @"Wrong initial parameters");
    return self;
}

- (NSDictionary *)jsonRepresentation {
    return @{
             kUUID : self.uuid,
             kImageUrl : self.imageUrl
             };
}

#pragma mark - NSObject

- (BOOL)isEqual:(MainEntity *)object {
    if([super isEqual:object]) {
        return YES;
    }
    
    if(![self isMemberOfClass:[object class]]) {
        return NO;
    }
    
    return [self.uuid isEqualToString:object.uuid] && [self.imageUrl isEqualToString:object.imageUrl];
}

- (NSUInteger)hash {
    return self.uuid.hash ^ self.imageUrl.hash;
}

@end
