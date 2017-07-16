//
//  TaskContainer.h
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Container for image load tasks. Used for proper calling of completion handlers
 */
@interface TaskContainer : NSObject

@property (nonatomic, weak) NSURLSessionTask *task;

@property (nonatomic, copy) void (^completionHandler)(id result);
@property (nonatomic, copy) void (^failureHandler)(NSError *error);

@end
