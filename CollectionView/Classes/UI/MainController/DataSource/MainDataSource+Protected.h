//
//  MainDataSource+Protected.h
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "MainDataSource.h"
#import <UIKit/UIKit.h>

/**
 Protocol for cell configurator: data source requests this info from secion managers
 */
@interface MainDataSource (Protected)

- (id)primaryInfoForCell:(UIView *)cell atIndexPath:(NSIndexPath*)indexPath;
- (NSArray <NSOperation *> *)querySecondaryInfoForCell:(UIView *)cell
                                           atIndexPath:(NSIndexPath*)indexPath
                                        withCompletion:(void (^)(id))completion;

@end
