//
//  ItemCellPrimaryInfo.h
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Main cells info
 */
@interface ItemCellPrimaryInfo : NSObject

@property (nonatomic, copy) void (^deleteTapHandler)();

@end
