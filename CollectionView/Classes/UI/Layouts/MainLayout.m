//
//  MainLayout.m
//  CollectionView
//
//  Created by Marina Shilnikova on 11.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "MainLayout.h"

@interface MainLayout ()

@property (nonatomic, strong) NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *>*cellLayoutInfo;
@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes*>*cellLayoutInfoArray;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, assign) CGFloat firstItemSize;

@end

@implementation MainLayout

#pragma mark - layout methods

- (void)prepareLayout {
    [super prepareLayout];
    
    self.cellLayoutInfo = [NSMutableDictionary dictionary];
    self.cellLayoutInfoArray = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    NSUInteger lastItem = 0;
    
    for (NSInteger section = 0; section<sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            CGRect frame = attributes.frame;
            
            if (lastItem == 0) {
                self.firstItemSize = frame.size.width;
            }
            attributes.frame = [self updateFrame:frame forItem:lastItem];
            lastItem ++;
            
            self.cellLayoutInfo[indexPath] = attributes;
            [self.cellLayoutInfoArray addObject:attributes];
        }
    }
    
    UICollectionViewLayoutAttributes *attributes = [self.cellLayoutInfoArray lastObject];
    self.totalHeight = CGRectGetMaxY(attributes.frame);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = self.cellLayoutInfo[indexPath];
    if (attribute) {
        return attribute;
    } else {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *finalAttributes = [NSMutableArray array];
    
    __block BOOL findFirst = NO;
    [self.cellLayoutInfoArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [finalAttributes addObject:attribute];
            findFirst = YES;
        } else {
            if (attribute.frame.origin.y > CGRectGetMaxY(rect)) {
                *stop = findFirst;
            }
        }
    }];
    
    return finalAttributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.totalHeight);
}

#pragma mark - utils

- (CGRect)updateFrame:(CGRect)frame forItem:(NSUInteger)item {
    //First three cells has custom positioning
    if (item == 0) {
        frame.origin.x = 0;
        frame.origin.y = 0;
        return frame;
    } else if (item == 1) {
        frame.origin.x = self.firstItemSize + self.minimumInteritemSpacing;
        frame.origin.y = 0;
        return frame;
    } else if (item == 2) {
        frame.origin.x = self.firstItemSize + self.minimumInteritemSpacing;
        frame.origin.y = frame.size.height + self.minimumLineSpacing;
        return frame;
    }
    
    int rowNumber = floor((CGFloat)item / 3.);
    
    //Calculate frame for a snake-style cells positioning
    BOOL isFirstRow = (rowNumber % 2 == 1);
    if (isFirstRow) {
        frame.origin.x = self.collectionView.frame.size.width - (frame.size.width) * (1 + item % 3) - self.minimumInteritemSpacing * (item % 3);
    } else {
        frame.origin.x = frame.size.width * (item % 3) + self.minimumInteritemSpacing * (item % 3);
    }
    frame.origin.y = ((rowNumber + 1) * frame.size.height) + (rowNumber + 1) * self.minimumLineSpacing;
    return frame;
}

@end
