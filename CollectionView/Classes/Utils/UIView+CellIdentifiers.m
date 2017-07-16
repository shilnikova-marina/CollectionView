//
//  UIView+CellIdentifiers.m
//  CollectionView
//
//  Created by Marina Shilnikova on 13.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "UIView+CellIdentifiers.h"

@implementation UIView (CellIdentifiers)

+ (NSString*)nibName {
    return NSStringFromClass([self class]);
}

+ (NSString*)reuseId {
    return NSStringFromClass([self class]);
}


@end
