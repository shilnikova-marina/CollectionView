//
//  MainDataLoader.h
//  CollectionView
//
//  Created by Marina Shilnikova on 13.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewModel.h"

/**
 Data loader for collection view screen
 */
@interface MainDataLoader : NSObject

- (instancetype)initWithModel:(MainViewModel *)viewModel;

- (void)loadDataWithCompletion:(void (^)(NSArray *result))completion;

@end
