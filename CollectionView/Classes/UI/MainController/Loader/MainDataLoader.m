//
//  MainDataLoader.m
//  CollectionView
//
//  Created by Marina Shilnikova on 13.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "MainDataLoader.h"
#import "MainViewModel.h"
#import "CollectionRequestManager.h"

@interface MainDataLoader ()

@property (nonatomic, weak) MainViewModel *viewModel;

@property (nonatomic, strong) CollectionRequestManager *requestsManager;

@end

@implementation MainDataLoader

- (instancetype)initWithModel:(MainViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        self.requestsManager = [[CollectionRequestManager alloc] init];
    }
    return self;
}

- (void)loadDataWithCompletion:(void (^)(NSArray *result))completion{
    __weak typeof(self) wSelf = self;
    [self.requestsManager requestAllItems:^(NSArray *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wSelf.viewModel.data addObjectsFromArray:result];
            completion(result);
        });
    }
                                  failure:^(NSError *error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [wSelf.viewModel.data removeAllObjects];
                                          completion(nil);
                                      });
                                  }];
}


@end
