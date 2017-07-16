//
//  AddSectionManager.m
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "AddSectionManager.h"
#import "AddCollectionViewCell.h"
#import "UIView+CellIdentifiers.h"
#import "MainViewModel.h"
#import "SectionsActionManager.h"

@interface AddSectionManager ()

@property (nonatomic, weak) MainViewModel *viewModel;

@property (nonatomic, assign) NSUInteger sectionIndex;

@property (nonatomic, strong) SectionsActionManager *actionManager;

@end

@implementation AddSectionManager

- (instancetype)initWithModel:(MainViewModel *)viewModel sectionIndex:(NSUInteger)sectionIndex {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        self.sectionIndex = sectionIndex;
        self.actionManager = [[SectionsActionManager alloc] initWithModel:viewModel];
    }
    return self;
}

- (void)registerViewsForCollectionView:(UICollectionView *)collectionView {
    UINib *nib = [UINib nibWithNibName:[AddCollectionViewCell nibName] bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:[AddCollectionViewCell reuseId]];
}

- (NSInteger)numberOfItems {
    return 1;
}

- (NSString *)reuseIdForItemAtIndex:(NSUInteger)index {
    return [AddCollectionViewCell reuseId];
}

- (BOOL)canMoveItemAtIndex:(NSUInteger)index {
    return NO;
}

- (void)moveItemAtIndex:(NSUInteger)index toIndex:(NSUInteger)destinationIndex {
    
}

- (void)moveItemAtIndex:(NSUInteger)index toSection:(NSUInteger)sectionIndex {

}

- (CGSize)sizeForItemAtIndex:(NSUInteger)index {
    //Calculate cell size based on the screen size
    CGFloat size = ([UIScreen mainScreen].bounds.size.width - 20)/3.;
    if (self.viewModel.data.count == 0) {
        return CGSizeMake(size*2+10, size*2+10);
    } else {
        return CGSizeMake(size, size);
    }
}

- (void)didSelectItemAtIndex:(NSUInteger)index {
    [self.actionManager addNewItem];
}

#pragma mark - cell configuration

- (id)primaryInfoForCellAtIndex:(NSUInteger)index {
    return nil;
}

- (NSArray <NSOperation *> *)querySecondaryInfoForCellAtIndex:(NSUInteger)index withCompletion:(void (^)(id))completion {
    return @[];
}

@end
