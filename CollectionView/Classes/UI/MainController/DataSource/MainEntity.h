//
//  MainEntity.h
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Main entity. Store uuid and image url. Can be serialized and deserialized to dictionary for easily json creation
 */
@interface MainEntity : NSObject

@property (nonatomic, strong) NSString *uuid;

@property (nonatomic, strong) NSString *imageUrl;

- (instancetype)initWithDictionary:(NSDictionary *)json;

- (NSDictionary *)jsonRepresentation;

@end
