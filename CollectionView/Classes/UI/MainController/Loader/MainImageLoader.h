//
//  MainImageLoader.h
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Image loader: load, resize and cache images
 */
@interface MainImageLoader : NSObject

/**
 Preferred size: use for resizing
 */
@property (nonatomic, assign) CGSize preferredImageSize;

- (NSOperation *)loadImageByURL:(NSString *)url
                 withCompletion:(void (^)(UIImage *image))completion
                        failure:(void (^)(NSError *error))failure;

@end
