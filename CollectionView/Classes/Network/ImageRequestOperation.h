//
//  ImageRequestOperation.h
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Image request operation: wrapper for network task
 */
@interface ImageRequestOperation : NSOperation

- (instancetype)initWithTask:(NSURLSessionTask *)dataTask;

@end
