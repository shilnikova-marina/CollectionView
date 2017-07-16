//
//  MainViewController.m
//  CollectionView
//
//  Created by Marina Shilnikova on 11.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "MainViewController.h"
#import "MainLayout.h"
#import "MainDataLoader.h"

#import "ItemsSectionManager.h"
#import "AddSectionManager.h"

#import "MainViewModel.h"
#import "MainDataSource.h"
#import "MainCollectionAnimator.h"


typedef NS_ENUM(NSUInteger, MainSection){
    MainSectionSmall = 0,
    MainSectionAdd
};

@interface MainViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MainDataLoader *dataLoader;
@property (nonatomic, strong) MainViewModel *viewModel;
@property (nonatomic, strong) MainDataSource *dataSource;
@property (nonatomic, strong) MainCollectionAnimator *collectionAnimator;

- (void)setupCollectionView;
- (void)handleLongGesture:(UILongPressGestureRecognizer *)recognizer;
- (void)configureSections;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[MainViewModel alloc] init];
    self.dataLoader = [[MainDataLoader alloc] initWithModel:self.viewModel];
    [self setupCollectionView];
    [self configureSections];
    
    __weak typeof(self) wSelf = self;
    [self.dataLoader loadDataWithCompletion:^(NSArray *result) {
        [wSelf.collectionView reloadData];
        wSelf.collectionAnimator = [[MainCollectionAnimator alloc] initWithCollectionView:self.collectionView viewModel:self.viewModel];
    }];
}

#pragma mark - configuration

- (void)setupCollectionView {
    MainLayout *layout = [[MainLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsZero;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
                                             collectionViewLayout:layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.view addSubview:self.collectionView];
    
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
    [self.collectionView addGestureRecognizer:gestureRecognizer];
}

- (void)handleLongGesture:(UILongPressGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[recognizer locationInView:self.collectionView]];
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self.collectionView updateInteractiveMovementTargetPosition:[recognizer locationInView:self.collectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
        }
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

- (void)configureSections {
    ItemsSectionManager *itemsSectionManager = [[ItemsSectionManager alloc] initWithModel:self.viewModel sectionIndex:MainSectionSmall];
    AddSectionManager *addSectionManager = [[AddSectionManager alloc] initWithModel:self.viewModel sectionIndex:MainSectionAdd];
    NSArray *sections = @[
                          itemsSectionManager,
                          addSectionManager
                          ];
    self.dataSource = [[MainDataSource alloc] initWithSections:sections];
    self.collectionView.delegate = self.dataSource;
    self.collectionView.dataSource = self.dataSource;
    
    for (id<MainSectionProtocol>section in sections) {
        [section registerViewsForCollectionView:self.collectionView];
    }
}

@end
