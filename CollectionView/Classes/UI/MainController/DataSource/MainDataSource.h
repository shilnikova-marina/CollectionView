//
//  MainDataSource.h
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSectionProtocol.h"

/**
 Data source for collection view. Transfers most of requests to appropriate collection view section
 */
@interface MainDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

- (instancetype)initWithSections:(NSArray <id<MainSectionProtocol>>*)sections;

@end
