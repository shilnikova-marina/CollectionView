//
//  SectionsActionManager.h
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainEntity;
@class MainViewModel;

/**
 Action manager for sections. Perform any action activites, network requests, show alerts
 */
@interface SectionsActionManager : NSObject

- (instancetype)initWithModel:(MainViewModel *)viewModel;

- (void)addNewItem;

- (void)selectItem:(MainEntity *)entity;

- (void)deleteItem:(MainEntity *)entity;

- (void)moveEntity:(MainEntity *)entity toPosition:(NSUInteger)position;

- (void)moveEntityToAnotherSection:(MainEntity *)entity;

@end
