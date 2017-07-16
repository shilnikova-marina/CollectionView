//
//  UIView+DataSourceTag.m
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "UIView+DataSourceTag.h"

#import <objc/runtime.h>

@implementation UIView (DataSourceTag)

- (NSString *)dataSourceTag {
    return objc_getAssociatedObject(self, @selector(dataSourceTag));
}

- (void)setDataSourceTag:(NSString *)dataSourceTag {
    objc_setAssociatedObject(self, @selector(dataSourceTag), dataSourceTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
