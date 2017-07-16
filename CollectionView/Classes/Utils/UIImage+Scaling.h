//
//  UIImage+Scaling.h
//  CollectionView
//
//  Created by Marina Shilnikova on 16.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Proportionally image scaling
 */
@interface UIImage (Scaling)

- (UIImage *)imageScalingProportionallyByMaxSize:(CGFloat)targetMaxSize;

@end
