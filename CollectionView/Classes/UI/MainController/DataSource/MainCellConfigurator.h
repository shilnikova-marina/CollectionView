//
//  MainCellConfigurator.h
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellConfigurationProtocol.h"

@class MainDataSource;

/**
 Configure cells with primary and secondary info. After obtain secondary info it checks cell availability
 */
@interface MainCellConfigurator : NSObject

- (instancetype)initWithDataSource:(MainDataSource *)dataSource;

- (void)configureCell:(UIView<CellConfigurationProtocol> *)cell atIndexPath:(NSIndexPath *)path;

- (void)cancelSecondaryConfiguration;

@end
