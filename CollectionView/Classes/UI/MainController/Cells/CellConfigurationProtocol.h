//
//  CellConfigurationProtocol.h
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//


/**
 Configuration protocol for cells. Primary info will be available instantly, secondary info can take some time for loading
 */
@protocol CellConfigurationProtocol <NSObject>

- (void)configureWithPrimaryInfo:(id)primaryInfo;
- (void)configureWithSecondaryInfo:(id)secondaryInfo;

@end
