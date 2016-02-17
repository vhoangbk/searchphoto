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
#import "TGRImageViewController.h"
#import "Utils.h"
#import "SDImageCache.h"

@interface PhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, PHPhotoLibraryChangeObserver>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollection;
@property PHFetchResult *allPhotosResult;
@property (nonatomic, strong) PHCachingImageManager *imageManager;


@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self requestPhotosAccessUsingPhotoLibrary];
}

- (void)requestPhotosAccessUsingPhotoLibrary {
    /*
     There are two ways to prompt the user for permission to access photos. This one will not display the photo picker UI.  See the UIImagePickerController example in this file for the other way to request photo access.
     */
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self checkAccessPhoto]) {
                [self initView];
            }else{
                [self alertViewWithMessage];
            }
                    
        });
    }];
}

- (void) initView{
    self.photoCollection.dataSource = self;
    self.photoCollection.delegate = self;
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self.imageManager stopCachingImagesForAllAssets];
    
    self.allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    [self.photoCollection registerClass:[ImageViewCell class] forCellWithReuseIdentifier:@"PhotoCellIdentity"];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (BOOL)checkAccessPhoto{
    if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
        return YES;
    }
    return NO;
}

- (void)alertViewWithMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Photo Download App does not have access to your photo, To enable access go to: iphone setting > privacy > photo > Photo Download" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = NSLocalizedString(@"all_photo", @"");
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - UICollectionViewDataSource
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
    
    // Request an image for the asset from the PHCachingImageManager.
    [self.imageManager requestImageForAsset:asset
                                 targetSize:cell.imageView.bounds.size
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                    [cell.imageView setImage:result];
                              }];

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat size = w/4.0f - 10;
    return CGSizeMake(size, size);
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSLog(@"photoLibraryDidChange");
    PHFetchResultChangeDetails *photoChanges =
    [changeInstance changeDetailsForFetchResult:self.allPhotosResult];
    if (photoChanges == nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.allPhotosResult = [photoChanges fetchResultAfterChanges];
        [self.photoCollection reloadData];
    });
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageViewCell *cell = (ImageViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:cell.imageView.image];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
//    [self updateCachedAssets];
}

#pragma mark - Asset

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
//    self.previousPreheatRect = CGRectZero;
}

//- (void)updateCachedAssets {
//    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
//    if (!isViewVisible) { return; }
//    
//    // The preheat window is twice the height of the visible rect.
//    CGRect preheatRect = self.collectionView.bounds;
//    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
//    
//    /*
//     Check if the collection view is showing an area that is significantly
//     different to the last preheated area.
//     */
//    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
//    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
//        
//        // Compute the assets to start caching and to stop caching.
//        NSMutableArray *addedIndexPaths = [NSMutableArray array];
//        NSMutableArray *removedIndexPaths = [NSMutableArray array];
//        
//        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
//            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
//            [removedIndexPaths addObjectsFromArray:indexPaths];
//        } addedHandler:^(CGRect addedRect) {
//            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
//            [addedIndexPaths addObjectsFromArray:indexPaths];
//        }];
//        
//        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
//        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
//        
//        // Update the assets the PHCachingImageManager is caching.
//        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
//                                            targetSize:AssetGridThumbnailSize
//                                           contentMode:PHImageContentModeAspectFill
//                                               options:nil];
//        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
//                                           targetSize:AssetGridThumbnailSize
//                                          contentMode:PHImageContentModeAspectFill
//                                              options:nil];
//        
//        // Store the preheat rect to compare against in the future.
//        self.previousPreheatRect = preheatRect;
//    }
//}

//- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
//    if (CGRectIntersectsRect(newRect, oldRect)) {
//        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
//        CGFloat oldMinY = CGRectGetMinY(oldRect);
//        CGFloat newMaxY = CGRectGetMaxY(newRect);
//        CGFloat newMinY = CGRectGetMinY(newRect);
//        
//        if (newMaxY > oldMaxY) {
//            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
//            addedHandler(rectToAdd);
//        }
//        
//        if (oldMinY > newMinY) {
//            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
//            addedHandler(rectToAdd);
//        }
//        
//        if (newMaxY < oldMaxY) {
//            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
//            removedHandler(rectToRemove);
//        }
//        
//        if (oldMinY < newMinY) {
//            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
//            removedHandler(rectToRemove);
//        }
//    } else {
//        addedHandler(newRect);
//        removedHandler(oldRect);
//    }
//}

//- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
//    if (indexPaths.count == 0) { return nil; }
//    
//    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
//    for (NSIndexPath *indexPath in indexPaths) {
//        PHAsset *asset = self.assetsFetchResults[indexPath.item];
//        [assets addObject:asset];
//    }
//    
//    return assets;
//}


@end
