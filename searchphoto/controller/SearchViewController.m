//
//  TopViewController.m
//  searchphoto
//
//  Created by Hoang Nguyen on 1/4/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultViewController.h"
#import "Const.h"
#import "Utils.h"
#import "ImageViewCell.h"
#import "AlbumCollectionViewCell.h"
#import "UIView+Toast.h"
#import "AlbumViewController.h"

@import Photos;


@interface SearchViewController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver>

@property (strong, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewAlbum;
@property PHFetchResult *pHFetchResultAlbum;
@property PHImageManager *phImageManger;

@end

@implementation SearchViewController


#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tfSearch.delegate = self;
    
    self.phImageManger = [[PHImageManager alloc] init];
    
    self.collectionViewAlbum.delegate = self;
    self.collectionViewAlbum.dataSource = self;
    
    self.pHFetchResultAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];

    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                        style:UIBarButtonItemStyleDone target:self action:@selector(handleAddButtonItem)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.title = @"Search Photo";
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
  PHFetchResultChangeDetails *collectionChanges =
      [changeInstance changeDetailsForFetchResult:self.self.pHFetchResultAlbum];
  if (collectionChanges == nil) {
    return;
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    self.pHFetchResultAlbum = [collectionChanges fetchResultAfterChanges];
    [self.collectionViewAlbum reloadData];
  });
}

#pragma mark - private method
- (IBAction)pressesSearchButton:(UIButton*)sender{
    ResultViewController *resultVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResultViewControllerIdentity"];
    NSString *strSearch = [self.tfSearch text];
    if ([strSearch length] > 0) {
        resultVC.strSearch = strSearch;
        [self.navigationController pushViewController:resultVC animated:YES];
    }else{
        NSLog(@"[SearchViewController] pressesSearchButton() text nil");
        [self.view makeToast:@"No input text to search"];
    }
    
}

- (void)handleAddButtonItem {
    // Prompt user from new album title.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"New Album", @"") message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Album Name", @"");
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:NULL]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Create", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alertController.textFields.firstObject;
        NSString *title = textField.text;
        if (title.length == 0) {
            return;
        }
        
        // Create a new album with the title entered.
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        } completionHandler:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"Error creating album: %@", error);
            }
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self.tfSearch resignFirstResponder];
    return YES;
}

#pragma mark - UIResponsder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tfSearch resignFirstResponder];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.pHFetchResultAlbum count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  AlbumCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumIdentity"
                                                forIndexPath:indexPath];

  PHAssetCollection *collection = self.pHFetchResultAlbum[indexPath.row];

  cell.lbName.text = collection.localizedTitle;

  PHFetchResult *assetsFetchResult =
      [PHAsset fetchAssetsInAssetCollection:collection options:nil];

  PHAsset *lastAsset = [assetsFetchResult lastObject];
  [self.phImageManger
      requestImageForAsset:lastAsset
                targetSize:cell.bounds.size
               contentMode:PHImageContentModeAspectFill
                   options:nil
             resultHandler:^(UIImage *result, NSDictionary *info) {
                 if (result != nil) {
                     [cell.imgAlbum setImage:result];
                 }else{
                     [cell.imgAlbum setImage:[UIImage imageNamed:@"folder"]];
                 }
               
             }];
  return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAssetCollection *collection = self.pHFetchResultAlbum[indexPath.row];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    
        AlbumViewController *showVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlbumViewControllerIdentity"];
        if ([assetsFetchResult count] > 0) {
            showVC.fetchPhoto = assetsFetchResult;
            showVC.album = collection.localizedTitle;
            [self.navigationController pushViewController:showVC animated:YES];
        }else{
            [self.view makeToast:@"Album empty"];
        }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat size = (w-30)/2.0;
    return CGSizeMake(size, size);
}


@end
