//
//  PhotoViewController.m
//  Searchphoto
//
//  Created by paraline on 1/8/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "PhotoViewController.h"
#import "ImageViewCell.h"

@import Photos;
#import "AppDelegate.h"

@interface PhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollection;
@property PHFetchResult *allPhotosResult;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoCollection.dataSource = self;
    self.photoCollection.delegate = self;
    
    self.allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    [self.photoCollection registerClass:[ImageViewCell class] forCellWithReuseIdentifier:@"PhotoCellIdentity"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.allPhotosResult count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCellIdentity"
                                                                    forIndexPath:indexPath];
    PHAsset *asset = [self.allPhotosResult objectAtIndex:indexPath.row];

    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        [cell.imageView setImage:[UIImage imageWithData:imageData]];
    }];

    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat size = (w-50)/4.0;
    return CGSizeMake(size, size);
}

@end
