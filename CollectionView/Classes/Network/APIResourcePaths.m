//
//  APIResourcePaths.m
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "APIResourcePaths.h"

@implementation APIResourcePaths

+ (NSString *)addPath {
    return @"mainEntity/add";
}
+ (NSString *)deletePath {
    return @"mainEntity/delete";
}
+ (NSString *)getPath {
    return @"mainEntity/get";
}
+ (NSString *)movePath {
    return @"mainEntity/move";
}

@end
