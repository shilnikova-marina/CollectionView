//
//  MainViewModel.m
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "MainViewModel.h"

@interface MainViewModel ()

@property (nonatomic, strong) NSArray *realData;

@end

@implementation MainViewModel
@synthesize realData;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.realData = [[NSArray alloc] init];
    }
    return self;
}

- (NSMutableArray*)data {
    return [self mutableArrayValueForKey:[self observableArrayKey]];
}

- (NSString *)observableArrayKey {
    return @"realData";
}

@end
