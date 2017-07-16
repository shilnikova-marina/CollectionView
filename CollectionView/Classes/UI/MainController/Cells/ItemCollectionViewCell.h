//
//  ItemCollectionViewCell.h
//  CollectionView
//
//  Created by Marina Shilnikova on 11.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellConfigurationProtocol.h"


/**
 Main collection view cell. Can be resized
 */
@interface ItemCollectionViewCell : UICollectionViewCell <CellConfigurationProtocol>

@end
