//
//  MainImageLoader.m
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "MainImageLoader.h"
#import "ImageRequestOperation.h"
#import "TaskContainer.h"
#import "UIImage+Scaling.h"

static const NSUInteger kMaxImageLoaderOperations = 20;

@interface MainImageLoader () <NSURLSessionDelegate>

@property (nonatomic, strong) NSCache *imageCache;

@property (nonatomic, strong) NSMutableDictionary *activeTasks;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation MainImageLoader

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
        self.activeTasks = [[NSMutableDictionary alloc] init];
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = kMaxImageLoaderOperations;
    }
    return self;
}

- (NSOperation *)loadImageByURL:(NSString *)url
                 withCompletion:(void (^)(UIImage *image))completion
                        failure:(void (^)(NSError *error))failure {
    UIImage *cachedObject = [self.imageCache objectForKey:url];
    if (cachedObject != nil) {
        completion(cachedObject);
        return nil;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.operationQueue];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:15];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    ImageRequestOperation *operation = [[ImageRequestOperation alloc] initWithTask:task];
    TaskContainer *container = [[TaskContainer alloc] init];
    container.task = task;
    container.completionHandler = completion;
    container.failureHandler = failure;
    [self saveTaskContainer:container forURL:url];
    [task resume];
    return operation;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSString *url = task.originalRequest.URL.absoluteString;
    if (![self.activeTasks.allKeys containsObject:url]) {
        //Not our task
        return;
    }
    
    //Resize and cache received data. Then notify all current task creators about this event
    if (error == nil) {
        NSError *dataError = nil;
        NSData *data = [NSData dataWithContentsOfURL:task.originalRequest.URL options:NSDataReadingMappedIfSafe error:&dataError];
        UIImage *image = [UIImage imageWithData:data];
        
        CGSize size = self.preferredImageSize;
        BOOL imageTooSmall = size.width > image.size.width && size.height > image.size.height;
        if (!imageTooSmall) {
            image = [image imageScalingProportionallyByMaxSize:size.width];
        }
        
        if (dataError == nil && image != nil) {
            [self.imageCache setObject:image forKey:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self notifyContainersByURL:url aboutImage:image];
            });
            return;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self notifyContainersByURL:url aboutError:error];
    });
}

#pragma mark - utils

- (void)saveTaskContainer:(TaskContainer *)container forURL:(NSString *)url {
    @synchronized (self) {
        NSMutableArray *containers = [self.activeTasks objectForKey:url];
        if (containers == nil) {
            containers = [[NSMutableArray alloc] init];
        }
        [containers addObject:container];
        [self.activeTasks setObject:containers forKey:url];
    }
}

- (void)notifyContainersByURL:(NSString *)url aboutImage:(UIImage *)image {
    @synchronized (self) {
        NSMutableArray *containers = [self.activeTasks objectForKey:url];
        for (TaskContainer *container in containers) {
            container.completionHandler(image);
        }
        [containers removeAllObjects];
    }
}

- (void)notifyContainersByURL:(NSString *)url aboutError:(NSError *)error {
    @synchronized (self) {
        NSMutableArray *containers = [self.activeTasks objectForKey:url];
        for (TaskContainer *container in containers) {
            container.failureHandler(error);
        }
        [containers removeAllObjects];
    }
}

@end
