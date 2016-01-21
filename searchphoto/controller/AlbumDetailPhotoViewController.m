//
//  AlbumDetailPhotoViewController.m
//  Searchphoto
//
//  Created by Hoang Nguyen on 1/15/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "AlbumDetailPhotoViewController.h"
#import "GalleryCell.h"

static NSString *const CellIdentifier = @"Cell";

@interface AlbumDetailPhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *galeryView;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@property BOOL initialScrollDone;

@end

@implementation AlbumDetailPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    self.galeryView.dataSource = self;
    self.galeryView.delegate = self;
    
    [self.galeryView registerClass:GalleryCell.class forCellWithReuseIdentifier:CellIdentifier];
    [self.galeryView setPagingEnabled:YES];
    
    self.initialScrollDone = NO;
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self.imageManager stopCachingImagesForAllAssets];
}

- (void)viewDidLayoutSubviews {
    
    // If we haven't done the initial scroll, do it once.
    if (!self.initialScrollDone) {
        self.initialScrollDone = YES;
        
        [self.galeryView scrollToItemAtIndexPath:self.currentIndex
                                    atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    PHAsset *asset = [self.resultCollection objectAtIndex:indexPath.row];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:cell.bounds.size
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  cell.image = result;
                              }];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.resultCollection count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.view.bounds.size;
}

- (IBAction)closeViewControler:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
