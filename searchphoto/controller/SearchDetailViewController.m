//
//  SearchDetailViewController.m
//  Searchphoto
//
//  Created by paraline on 1/5/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "Utils.h"
#import "Const.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"

@import Photos;

#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface SearchDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPresent;
@property (strong, nonatomic) NSMutableArray *arrayPHAssetCollection;
@property PHFetchResult *pHFetchResultAlbum;

@end

@implementation SearchDetailViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"back", @"");
    
    self.title = [[[self.urlImage absoluteString] componentsSeparatedByString:@"/"] lastObject];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.imgPresent sd_setImageWithURL:self.urlImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self.view makeToast:@"error" duration:3.0 position:CSToastPositionCenter];
        }
    }];
    
    self.arrayPHAssetCollection = [[NSMutableArray alloc] init];
    
    self.pHFetchResultAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    [self.pHFetchResultAlbum enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayPHAssetCollection addObject:obj];
    }];
    
}

#pragma mark - private method

- (IBAction)handleSaveButtonItem:(id)sender {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"select_album", @"")
                                          message:@""
                                   preferredStyle:UIAlertControllerStyleAlert];
    for (PHAssetCollection *album in self.arrayPHAssetCollection) {
    UIAlertAction *action =
        [UIAlertAction actionWithTitle:album.localizedTitle
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {

                                 [self saveImage:album];

                               }];
        [alert addAction:action];
  }

  UIAlertAction *cancel =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                               style:UIAlertActionStyleDefault
                             handler:nil];

  [alert addAction:cancel];

  [self presentViewController:alert animated:YES completion:nil];

}

- (void)saveImage:(PHAssetCollection *)collection {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:self.urlImage
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                                    BOOL finished, NSURL *imageURL) {
                            if (image) {
                                // do something with image
                                [self addNewAssetWithImage:image toAlbum:collection];
                            }
                        }];
}

- (void)addNewAssetWithImage:(UIImage *)image toAlbum:(PHAssetCollection *)album{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // Request creating an asset from the image.
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        // Request editing the album.
        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        
        // Get a placeholder for the new asset and add it to the album editing request.
        PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
        [albumChangeRequest addAssets:@[ assetPlaceholder ]];
        
    } completionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (success) {
                [self.view makeToast:NSLocalizedString(@"add_photo_sucess", @"") duration:3.0 position:CSToastPositionCenter];
            }else{
                [self.view makeToast:NSLocalizedString(@"add_photo_error", @"") duration:3.0 position:CSToastPositionCenter];
            }
        });
        
    }];
}

@end
