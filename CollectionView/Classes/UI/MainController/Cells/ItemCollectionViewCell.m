//
//  ItemCollectionViewCell.m
//  CollectionView
//
//  Created by Marina Shilnikova on 11.07.17.
//  Copyright © 2017 gusenica. All rights reserved.
//

#import "ItemCollectionViewCell.h"
#import "ItemCellPrimaryInfo.h"

static const CGFloat deleteButtonSize = 44;

@interface ItemCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteButton;
- (IBAction)onDeleteTap:(id)sender;

@property (nonatomic, copy) void (^deleteTapHandler)();

@end

@implementation ItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setTitle:@"x" forState:UIControlStateNormal];
        [self.deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteButton];
        [self.deleteButton addTarget:self action:@selector(onDeleteTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - UIView methods

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
    self.deleteButton.frame = CGRectMake(self.contentView.bounds.size.width - deleteButtonSize, 0, deleteButtonSize, deleteButtonSize);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

#pragma mark - configuration

- (void)configureWithPrimaryInfo:(ItemCellPrimaryInfo *)primaryInfo {
    //Store delete tap info for pass it back to section manager
    self.deleteTapHandler = primaryInfo.deleteTapHandler;
}

- (void)configureWithSecondaryInfo:(UIImage *)image {
    self.imageView.image = image;
    if(image != nil) {
        self.imageView.backgroundColor = [UIColor clearColor];
    } else {
        self.imageView.backgroundColor = [UIColor colorWithRed:113./255. green:163./255. blue:242./255. alpha:1.];
    }
}

#pragma mark - actions

- (IBAction)onDeleteTap:(id)sender {
    if (self.deleteTapHandler) {
        self.deleteTapHandler();
    }
}

@end
