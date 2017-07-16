//
//  ImageRequestOperation.m
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "ImageRequestOperation.h"


@interface ImageRequestOperation ()

/**
 *  Task
 */
@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation ImageRequestOperation

- (instancetype)initWithTask:(NSURLSessionTask *)dataTask {
    self = [super init];
    if (self) {
        self.task = dataTask;
    }
    return self;
}

- (BOOL)isReady {
    return self.task.state == NSURLSessionTaskStateSuspended;
}

- (BOOL)isExecuting {
    return self.task.state == NSURLSessionTaskStateRunning;
}

- (BOOL)isFinished {
    return self.task.state == NSURLSessionTaskStateCompleted;
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)start {
    [self.task resume];
}

- (void)cancel {
    [self.task cancel];
}

@end
