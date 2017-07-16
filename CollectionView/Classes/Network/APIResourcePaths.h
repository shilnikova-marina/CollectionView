//
//  APIResourcePaths.h
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Api paths for identify requests
 */
@interface APIResourcePaths : NSObject

+ (NSString *)addPath;
+ (NSString *)deletePath;
+ (NSString *)getPath;
+ (NSString *)movePath;

@end
