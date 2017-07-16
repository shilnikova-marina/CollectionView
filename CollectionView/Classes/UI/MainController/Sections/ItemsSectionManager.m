//
//  ItemsSectionManager.m
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "ItemsSectionManager.h"
#import "ItemCollectionViewCell.h"
#import "UIView+CellIdentifiers.h"
#import "MainViewModel.h"
#import "MainEntity.h"
#import "MainImageLoader.h"
#import "ItemCellPrimaryInfo.h"
#import "SectionsActionManager.h"

@interface ItemsSectionManager ()

@property (nonatomic, weak) MainViewModel *viewModel;

@property (nonatomic, assign) NSUInteger sectionIndex;

@property (nonatomic, strong) MainImageLoader *imageLoader;

@property (nonatomic, strong) SectionsActionManager *actionManager;

@end

@implementation ItemsSectionManager

- (instancetype)initWithModel:(MainViewModel *)viewModel sectionIndex:(NSUInteger)sectionIndex {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        self.sectionIndex = sectionIndex;
        self.imageLoader = [[MainImageLoader alloc] init];
        self.imageLoader.preferredImageSize = [self sizeForItemAtIndex:0];
        self.actionManager = [[SectionsActionManager alloc] initWithModel:viewModel];
    }
    return self;
}

- (void)registerViewsForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[ItemCollectionViewCell class] forCellWithReuseIdentifier:[ItemCollectionViewCell reuseId]];
}

- (NSInteger)numberOfItems {
    return self.viewModel.data.count;
}

- (NSString *)reuseIdForItemAtIndex:(NSUInteger)index {
    return [ItemCollectionViewCell reuseId];
}

- (BOOL)canMoveItemAtIndex:(NSUInteger)index {
    return (index < self.viewModel.data.count);
}

- (void)moveItemAtIndex:(NSUInteger)index toIndex:(NSUInteger)destinationIndex {
    MainEntity *entity = self.viewModel.data[index];
    [self.actionManager moveEntity:entity toPosition:destinationIndex];
}

- (void)moveItemAtIndex:(NSUInteger)index toSection:(NSUInteger)sectionIndex {
    MainEntity *entity = self.viewModel.data[index];
    [self.actionManager moveEntityToAnotherSection:entity];
}

- (CGSize)sizeForItemAtIndex:(NSUInteger)index {
    //Calculate cell size based on the screen size
    CGFloat size = ([UIScreen mainScreen].bounds.size.width - 20)/3.;
    if (index == 0) {
        return CGSizeMake(size*2+10, size*2+10);
    } else {
        return CGSizeMake(size, size);
    }
}

- (void)didSelectItemAtIndex:(NSUInteger)index {
    MainEntity *entity = self.viewModel.data[index];
    [self.actionManager selectItem:entity];
}

#pragma mark - cell configuration

- (id)primaryInfoForCellAtIndex:(NSUInteger)index {
    MainEntity *entity = self.viewModel.data[index];
    ItemCellPrimaryInfo *info = [[ItemCellPrimaryInfo alloc] init];
    __weak typeof(self) wSelf = self;
    info.deleteTapHandler = ^{
        [wSelf.actionManager deleteItem:entity];
    };
    return info;
}

- (NSArray <NSOperation *> *)querySecondaryInfoForCellAtIndex:(NSUInteger)index withCompletion:(void (^)(id))completion {
    MainEntity *entity = self.viewModel.data[index];
    NSOperation *operation = [self.imageLoader loadImageByURL:entity.imageUrl
                                               withCompletion:^(UIImage *image) {
                                                   completion(image);
                                               }
                                                      failure:^(NSError *error) {
                                                          completion(nil);
                                                      }];
    return (operation == nil) ? @[] : @[operation];
}

@end
