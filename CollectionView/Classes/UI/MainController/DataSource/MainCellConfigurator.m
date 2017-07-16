//
//  MainCellConfigurator.m
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "MainCellConfigurator.h"
#import "UIView+DataSourceTag.h"
#import "MainDataSource+Protected.h"

@interface MainCellConfigurator ()

/**
 *  Active async operations associated with tag (NSString, NSArray)
 */
@property (nonatomic, strong) NSMutableDictionary *tagToActiveOperations;

@property (nonatomic, weak) MainDataSource *dataSource;

- (void)cancelOperationsForTag:(NSString *)tag;

@end

@implementation MainCellConfigurator

- (instancetype)initWithDataSource:(MainDataSource *)dataSource {
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
    }
    return self;
}

- (void)dealloc {
    [self cancelSecondaryConfiguration];
}

- (NSMutableDictionary *)tagToActiveOperations {
    if (_tagToActiveOperations == nil) {
        _tagToActiveOperations = [[NSMutableDictionary alloc] init];
    }
    return _tagToActiveOperations;
}

#pragma mark - Public methods

- (void)configureCell:(UIView<CellConfigurationProtocol> *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (cell.dataSourceTag != nil) {
        [self cancelOperationsForTag:cell.dataSourceTag];
    }
    
    cell.dataSourceTag = nil;
    [cell configureWithPrimaryInfo:[self.dataSource primaryInfoForCell:cell atIndexPath:indexPath]];

    cell.dataSourceTag = [NSProcessInfo processInfo].globallyUniqueString;
    NSString *tag = cell.dataSourceTag;
    
    __weak UIView<CellConfigurationProtocol> *wCell = cell;
    __weak typeof(self) wSelf = self;
    NSArray *operations = [self.dataSource querySecondaryInfoForCell:cell atIndexPath:indexPath withCompletion:^(id info) {
        if(![wCell.dataSourceTag isEqual:tag]) {
            return;
        }
        [wSelf.tagToActiveOperations removeObjectForKey:tag];
        [wCell configureWithSecondaryInfo:info];
    }];
    
    if(operations.count > 0) {
        self.tagToActiveOperations[tag] = operations;
    }
}

- (void)cancelSecondaryConfiguration {
    NSArray *tagsToRemove = [self.tagToActiveOperations allKeys];
    [tagsToRemove enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        [self cancelOperationsForTag:obj];
    }];
}

#pragma mark - Secondary configuration

- (void)cancelOperationsForTag:(NSString *)tag {
    NSArray *operations = self.tagToActiveOperations[tag];
    if(operations.count <= 0) {
        return;
    }
    
    [operations enumerateObjectsUsingBlock:^(NSOperation *obj, NSUInteger idx, BOOL *stop) {
        [obj cancel];
    }];
    
    [self.tagToActiveOperations removeObjectForKey:tag];
}

@end
