//
//  ShowPhotoViewController.m
//  Searchphoto
//
//  Created by paraline on 1/5/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"
#import "Const.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"

@import Photos;

@interface ShowPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPresent;
@property (strong, nonatomic) NSMutableArray *arrayPHAssetCollection;
@property PHFetchResult *pHFetchResultAlbum;

@end

@implementation ShowPhotoViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.title = [[[self.urlImage absoluteString] componentsSeparatedByString:@"/"] lastObject];
    
//    if (self.urlImage != nil) {
//        [self.imgPresent setImageWithURL:self.urlImage];
//    }else{
        [self.imgPresent setImageWithURL:self.urlImageThum];
//    }
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(handleSaveButtonItem)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.arrayPHAssetCollection = [[NSMutableArray alloc] init];
    
    self.pHFetchResultAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    [self.pHFetchResultAlbum enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayPHAssetCollection addObject:obj];
    }];
}

#pragma mark - private method

- (void)handleSaveButtonItem {
    UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:@"Select album"
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
      [UIAlertAction actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                             handler:nil];

  [alert addAction:cancel];

  [self presentViewController:alert animated:YES completion:nil];
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
            NSLog(@"add photo sucess");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if (success) {
//                [self.view makeToast:@"Add photo sucess"];
//            }else{
//                [self.view makeToast:@"Add photo error"];
//            }
        });
        
    }];
}

- (void)saveImage : (PHAssetCollection*) collection{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSData *dataImage = [NSData dataWithContentsOfURL:self.urlImage];
        UIImage *image = [UIImage imageWithData:dataImage];
        
        [self addNewAssetWithImage:image toAlbum:collection];
    
}

@end
