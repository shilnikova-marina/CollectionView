//
//  MainCollectionAnimator.h
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MainViewModel;

/**
 Animator for collection view. Adds KVO to model's data and updates collection view if needed
 */
@interface MainCollectionAnimator : NSObject

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView viewModel:(MainViewModel *)viewModel;

@end
