//
//  AlbumDetailViewController.m
//  Searchphoto
//
//  Created by paraline on 1/6/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "AlbumDetailViewController.h"
#import "ImageViewCell.h"
#import "AlbumDetailPhotoViewController.h"

static NSString *kAlbumDetailPhotoViewController = @"AlbumDetailPhotoViewController";

@interface AlbumDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionPhoto;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end

@implementation AlbumDetailViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"back", @"");
    
    [self.collectionPhoto registerClass:[ImageViewCell class] forCellWithReuseIdentifier:@"ImagePhotoIdentity"];
    
    self.collectionPhoto.dataSource = self;
    self.collectionPhoto.delegate = self;
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self.imageManager stopCachingImagesForAllAssets];
}

- (void)viewDidAppear:(BOOL)animated{
    self.title = self.album;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.fetchPhoto count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImagePhotoIdentity"
                                                                              forIndexPath:indexPath];

    PHAsset *asset = [self.fetchPhoto objectAtIndex:indexPath.row];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:cell.imageView.bounds.size
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  [cell.imageView setImage:result];
                              }];

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    AlbumDetailPhotoViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kAlbumDetailPhotoViewController];
//    
//    viewController.currentIndex = indexPath;
//    viewController.resultCollection = self.fetchPhoto;
//
//    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat size = (w-30)/2.0;
    return CGSizeMake(size, size);
}

@end
