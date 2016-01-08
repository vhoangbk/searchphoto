//
//  ShowGaleryViewController.m
//  Searchphoto
//
//  Created by paraline on 1/8/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "ShowGaleryViewController.h"
#import "UIPhotoGalleryView.h"

@import Photos;
#import "SDWebImageManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

@interface ShowGaleryViewController () <UIPhotoGalleryDataSource, UIPhotoGalleryDelegate>

@property (weak, nonatomic) IBOutlet UIPhotoGalleryView *galeryView;
@property PHFetchResult *pHFetchResultAlbum;

@end

@implementation ShowGaleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.galeryView.showsScrollIndicator = NO;
    self.galeryView.peakSubView = YES;
    
    self.galeryView.dataSource = self;
    self.galeryView.delegate = self;
    
    
    self.galeryView.galleryMode = UIPhotoGalleryModeImageRemote;
    [self.galeryView setInitialIndex:self.currentIndex];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(handleSaveButtonItem)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.pHFetchResultAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
}


- (void)handleSaveButtonItem {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Select album"
                                        message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    for (PHAssetCollection *album in self.pHFetchResultAlbum) {
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

- (void)saveImage:(PHAssetCollection *)collection {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[self.arrayUrl objectAtIndex:self.currentIndex]
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
            NSLog(@"add photo sucess");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (success) {
                [self.view makeToast:@"Add photo sucess"];
            }else{
                [self.view makeToast:@"Add photo error"];
            }
        });
        
    }];
}

#pragma mark - UIPhotoGalleryDataSource
- (NSInteger)numberOfViewsInPhotoGallery:(UIPhotoGalleryView *)photoGallery{
    return [self.arrayUrl count];
}

- (NSURL*)photoGallery:(UIPhotoGalleryView *)photoGallery remoteImageURLAtIndex:(NSInteger)index {
    return [self.arrayUrl objectAtIndex:index];
}

#pragma mark - UIPhotoGalleryDelegate
- (void)photoGallery:(UIPhotoGalleryView *)photoGallery didMoveToIndex:(NSInteger)index{
    NSLog(@"didMoveToIndex %d currentindex:%d", index, photoGallery.currentIndex);
    self.currentIndex = index;
}

- (IBAction)backAction:(id)sender {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionFade];
    [self.navigationController.view.layer addAnimation:transition forKey:@"someAnimation"];
    
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];

}

@end
