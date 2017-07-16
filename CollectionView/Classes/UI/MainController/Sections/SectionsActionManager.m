//
//  SectionsActionManager.m
//  CollectionView
//
//  Created by Marina Shilnikova on 15.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "SectionsActionManager.h"
#import "MainViewModel.h"
#import "MainEntity.h"
#import <UIKit/UIKit.h>
#import "CollectionRequestManager.h"

@interface SectionsActionManager ()

@property (nonatomic, weak) MainViewModel *viewModel;

@property (nonatomic, strong) CollectionRequestManager *requestManager;

@end

@implementation SectionsActionManager

- (instancetype)initWithModel:(MainViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        self.requestManager = [[CollectionRequestManager alloc] init];
    }
    return self;
}

- (void)addNewItem {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"🐱"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Link";
    }];
    
    __weak typeof(self) wSelf = self;
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *url = alert.textFields[0].text;
        [wSelf createNewEntityWithUrl:url];
    }];
    [alert addAction:okButton];
    
    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelButton];
    
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:^{}];
}

- (void)selectItem:(MainEntity *)entity {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"🐱"
                                 message:[NSString stringWithFormat:@"You have selected the item with identifier %@", entity.uuid]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Great!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:yesButton];
    
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:^{}];
}

- (void)deleteItem:(MainEntity *)entity {
    __weak typeof(self) wSelf = self;
    [self.requestManager deleteEntity:entity
                              success:^{
                                  //I add interface changes for add and delete entities only after network requests.
                                  //It can be changed, but all this behavior should be discussed with designer/project manager
                                  [wSelf.viewModel.data removeObjectAtIndex:[wSelf.viewModel.data indexOfObject:entity]];
                              }
                              failure:^(NSError *error) {
                                  //Show sad alert to user?
                              }];
}

- (void)moveEntity:(MainEntity *)entity toPosition:(NSUInteger)position {
    __weak typeof(self) wSelf = self;
    [self.requestManager moveEntity:entity
                         toPosition:position
                            success:^{
                                //Perform update without animation: collection view already did all visual part
                                [wSelf.viewModel setUpdateState:DataSilentUpdate];
                                [wSelf.viewModel.data removeObjectAtIndex:[wSelf.viewModel.data indexOfObject:entity]];
                                [wSelf.viewModel.data insertObject:entity atIndex:position];
                                [wSelf.viewModel setUpdateState:DataNormalUpdate];
                            }
                            failure:^(NSError *error) {
                                //Update indexes of switched cells for reload data inside
                                [wSelf.viewModel setUpdateState:DataBatchUpdate];
                                [wSelf.viewModel.data replaceObjectAtIndex:position withObject:[wSelf.viewModel.data objectAtIndex:position]];
                                [wSelf.viewModel.data replaceObjectAtIndex:[wSelf.viewModel.data indexOfObject:entity] withObject:entity];
                                [wSelf.viewModel setUpdateState:DataNormalUpdate];
                            }];
}

- (void)moveEntityToAnotherSection:(MainEntity *)entity {
    [self.viewModel setUpdateCollectionSignal:[NSObject new]];
}

#pragma mark - private

- (void)createNewEntityWithUrl:(NSString *)url {
    if (url.length == 0) {
        return;
    }
    
    NSURL *testURL = [NSURL URLWithString:url];
    if (testURL && testURL.scheme && testURL.host) {
        MainEntity *entity = [[MainEntity alloc] init];
        entity.uuid = [[[NSUUID UUID] UUIDString] lowercaseString];
        entity.imageUrl = url;
        __weak typeof(self) wSelf = self;
        [self.requestManager addEntity:entity success:^{
            //I add interface changes for add and delete entities only after network requests.
            //It can be changed, but all this behavior should be discussed with designer/project manager
            [wSelf.viewModel.data addObject:entity];
        }
                               failure:^(NSError *error) {
                                   //Show sad alert to user?
                               }];
    } else {
        //Show sad alert to user?
    }
}

@end
