//
//  MainViewModel.h
//  CollectionView
//
//  Created by Marina Shilnikova on 12.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainEntity;

typedef NS_ENUM(NSUInteger, DataUpdateState){
    DataNormalUpdate = 0,
    DataBatchUpdate,
    DataSilentUpdate
};

/**
 Model stores observable data array
 */
@interface MainViewModel : NSObject

/**
 Data array created during initialization. Observable by observableArrayKey
 */
@property (nonatomic, strong, readonly) NSMutableArray <MainEntity *>*data;

/**
 Data update state for animations
 */
@property (nonatomic, assign) DataUpdateState updateState;

/**
 Signal to reload all collection
 */
@property (nonatomic, strong) NSObject *updateCollectionSignal;

/**
 Key for observe data changes
 */
- (NSString *)observableArrayKey;

@end
