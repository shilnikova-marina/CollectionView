//
//  UIView+CellIdentifiers.h
//  CollectionView
//
//  Created by Marina Shilnikova on 13.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Cell identifiers for simplify collection view bindings
 */
@interface UIView (CellIdentifiers)

+ (NSString*)nibName;

+ (NSString*)reuseId;

@end
