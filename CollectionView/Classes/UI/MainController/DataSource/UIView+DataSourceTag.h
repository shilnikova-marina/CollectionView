//
//  UIView+DataSourceTag.h
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DataSourceTag)
/**
 *  Tag for identify view for data source configuration
 */
@property (nonatomic, strong) NSString *dataSourceTag;

@end
