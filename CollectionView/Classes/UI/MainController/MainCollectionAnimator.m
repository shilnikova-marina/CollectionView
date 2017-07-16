//
//  MainCollectionAnimator.m
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "MainCollectionAnimator.h"
#import "MainViewModel.h"

@interface MainCollectionAnimator ()

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) MainViewModel *viewModel;

@property (nonatomic, strong) NSMutableIndexSet *transactionInsertedIndexes;
@property (nonatomic, strong) NSMutableIndexSet *transactionUpdatedIndexes;
@property (nonatomic, strong) NSMutableIndexSet *transactionDeletedIndexes;


- (void)setupObservers;
- (void)removeObservers;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context;

- (void)animateUpdateWithDeleted:(NSIndexSet *)deletedIndexes inserted:(NSIndexSet *)insertedIndexes updated:(NSIndexSet *)updatedIndexes;
- (NSMutableArray *)indexPathsFromIndexSet:(NSIndexSet *)indexSet forSection:(NSInteger)section;

@end

@implementation MainCollectionAnimator

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView viewModel:(MainViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
        self.viewModel = viewModel;
        self.transactionDeletedIndexes = [[NSMutableIndexSet alloc] init];
        self.transactionUpdatedIndexes = [[NSMutableIndexSet alloc] init];
        self.transactionInsertedIndexes = [[NSMutableIndexSet alloc] init];
        [self setupObservers];
    }
    return self;
}

- (void)dealloc {
    [self removeObservers];
}

#pragma mark - observations

- (void)setupObservers {
    [self.viewModel addObserver:self
                     forKeyPath:[self.viewModel observableArrayKey]
                        options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                        context:nil];
    [self.viewModel addObserver:self
                     forKeyPath:@"updateState"
                        options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                        context:nil];
    [self.viewModel addObserver:self
                     forKeyPath:@"updateCollectionSignal"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
}

- (void)removeObservers {
    [self.viewModel removeObserver:self forKeyPath:[self.viewModel observableArrayKey]];
    [self.viewModel removeObserver:self forKeyPath:@"updateState"];
    [self.viewModel removeObserver:self forKeyPath:@"updateCollectionSignal"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    id old = [change objectForKey:NSKeyValueChangeOldKey];
    if (old == [NSNull null]) old = nil;
    
    id new = [change objectForKey:NSKeyValueChangeNewKey];
    if (new == [NSNull null]) new = nil;
    
    if ([keyPath isEqualToString:[self.viewModel observableArrayKey]]) {
        
        NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
        NSIndexSet *indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
        
        //Animate changed indexes immediately if current view model state is default.
        //Or add them to storage for transaction animation or for silent animation
        switch (changeKind) {
            case NSKeyValueChangeSetting: {
                [self animateUpdateWithDeleted:nil inserted:nil updated:nil];
            }
                break;
            case NSKeyValueChangeInsertion: {
                if (self.viewModel.updateState == DataNormalUpdate) {
                    [self animateUpdateWithDeleted:nil inserted:indexes updated:nil];
                } else {
                    [self.transactionInsertedIndexes addIndexes:indexes];
                }
            }
                break;
            case NSKeyValueChangeRemoval: {
                if (self.viewModel.updateState == DataNormalUpdate) {
                    [self animateUpdateWithDeleted:indexes inserted:nil updated:nil];
                } else {
                    [self.transactionDeletedIndexes addIndexes:indexes];
                }
            }
                break;
            case NSKeyValueChangeReplacement: {
                if (self.viewModel.updateState == DataNormalUpdate) {
                    [self animateUpdateWithDeleted:nil inserted:nil updated:indexes];
                } else {
                    [self.transactionUpdatedIndexes addIndexes:indexes];
                }
            }
                break;
        }
    } else if ([keyPath isEqualToString:@"updateState"]) {
        //If state changed from silent update or batch update: update is ended now, we can perform animation if needed
        if ([new unsignedIntegerValue] == DataNormalUpdate) {
            if ([old unsignedIntegerValue] == DataBatchUpdate) {
                [self animateUpdateWithDeleted:self.transactionDeletedIndexes
                                      inserted:self.transactionInsertedIndexes
                                       updated:self.transactionUpdatedIndexes];
            }
            self.transactionDeletedIndexes = [[NSMutableIndexSet alloc] init];
            self.transactionUpdatedIndexes = [[NSMutableIndexSet alloc] init];
            self.transactionInsertedIndexes = [[NSMutableIndexSet alloc] init];
        }
    } else {
        //Reloads data by view model's signal
        __weak typeof(self) wSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wSelf.collectionView reloadData];
        });
    }
}

#pragma mark - animations

- (void)animateUpdateWithDeleted:(NSIndexSet *)deletedIndexes inserted:(NSIndexSet *)insertedIndexes updated:(NSIndexSet *)updatedIndexes {
    if (deletedIndexes.count == 0 && insertedIndexes == 0 && updatedIndexes == 0) {
        return;
    }
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.35 animations:^{
            [self.collectionView performBatchUpdates:^ {
                //For this task all animations can be performed only in first section
                [wSelf.collectionView deleteItemsAtIndexPaths:[wSelf indexPathsFromIndexSet:deletedIndexes forSection:0]];
                [wSelf.collectionView insertItemsAtIndexPaths:[wSelf indexPathsFromIndexSet:insertedIndexes forSection:0]];
                [wSelf.collectionView reloadItemsAtIndexPaths:[wSelf indexPathsFromIndexSet:updatedIndexes forSection:0]];
            } completion:^(BOOL finished) {
                [wSelf.collectionView layoutIfNeeded];
            }];
        }];
    });
}

- (NSMutableArray *)indexPathsFromIndexSet:(NSIndexSet *)indexSet forSection:(NSInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:section]];
    }];
    
    return indexPaths;
}

@end
