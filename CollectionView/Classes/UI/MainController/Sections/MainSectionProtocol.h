//
//  MainSectionProtocol.h
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewModel;

/**
 Protocol for section managers: sections respond to all collection view configuration requests
 */
@protocol MainSectionProtocol <UICollectionViewDelegate>

- (instancetype)initWithModel:(MainViewModel *)viewModel sectionIndex:(NSUInteger)sectionIndex;

- (void)registerViewsForCollectionView:(UICollectionView *)collectionView;

#pragma mark - identification

- (NSUInteger)sectionIndex;

#pragma mark - collection view info

- (NSInteger)numberOfItems;

- (NSString *)reuseIdForItemAtIndex:(NSUInteger)index;

- (BOOL)canMoveItemAtIndex:(NSUInteger)index;

- (void)moveItemAtIndex:(NSUInteger)index toIndex:(NSUInteger)index;

- (void)moveItemAtIndex:(NSUInteger)index toSection:(NSUInteger)sectionIndex;

- (CGSize)sizeForItemAtIndex:(NSUInteger)index;

- (void)didSelectItemAtIndex:(NSUInteger)index;

#pragma mark - cell configuration info

- (id)primaryInfoForCellAtIndex:(NSUInteger)index;

- (NSArray <NSOperation *> *)querySecondaryInfoForCellAtIndex:(NSUInteger)index withCompletion:(void (^)(id))completion;

@end
