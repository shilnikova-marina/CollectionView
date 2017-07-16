//
//  MainDataSource.m
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "MainDataSource.h"

#import "ItemCollectionViewCell.h"
#import "MainCellConfigurator.h"
#import "MainDataSource+Protected.h"

@interface MainDataSource ()

@property (nonatomic, strong) NSArray <id<MainSectionProtocol>>* sections;

@property (nonatomic, strong) MainCellConfigurator *cellConfigurator;

@end

@implementation MainDataSource

- (instancetype)initWithSections:(NSArray<id<MainSectionProtocol>> *)sections {
    self = [super init];
    if (self) {
        self.sections = sections;
        self.cellConfigurator = [[MainCellConfigurator alloc] initWithDataSource:self];
    }
    return self;
}

#pragma mark - collection view methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self sectionForIndex:section] numberOfItems];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = [[self sectionForIndex:indexPath.section] reuseIdForItemAtIndex:indexPath.row];
    UICollectionViewCell <CellConfigurationProtocol>*cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    [self.cellConfigurator configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self sectionForIndex:indexPath.section] canMoveItemAtIndex:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView
   moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath*)destinationIndexPath {
    if (sourceIndexPath.section == destinationIndexPath.section) {
        [[self sectionForIndex:sourceIndexPath.section] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
    } else {
        [[self sectionForIndex:sourceIndexPath.section] moveItemAtIndex:sourceIndexPath.row toSection:destinationIndexPath.section];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self sectionForIndex:indexPath.section] sizeForItemAtIndex:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[self sectionForIndex:indexPath.section] didSelectItemAtIndex:indexPath.row];
}

#pragma mark - protected

- (id)primaryInfoForCell:(UIView *)cell atIndexPath:(NSIndexPath*)indexPath {
    return [[self sectionForIndex:indexPath.section] primaryInfoForCellAtIndex:indexPath.row];
}
- (NSArray <NSOperation *> *)querySecondaryInfoForCell:(UIView *)cell
                                           atIndexPath:(NSIndexPath*)indexPath
                                        withCompletion:(void (^)(id))completion {
    return [[self sectionForIndex:indexPath.section] querySecondaryInfoForCellAtIndex:indexPath.row withCompletion:completion];
}

#pragma mark - private

- (id<MainSectionProtocol>)sectionForIndex:(NSUInteger)index {
    return self.sections[index];
}

@end
