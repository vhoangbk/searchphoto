//
//  TopViewController.m
//  searchphoto
//
//  Created by Hoang Nguyen on 1/4/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "AlbumViewController.h"
#import "SearchViewController.h"
#import "Const.h"
#import "Utils.h"
#import "ImageViewCell.h"
#import "AlbumCollectionViewCell.h"
#import "UIView+Toast.h"
#import "AlbumDetailViewController.h"

@import Photos;

static NSString *kAlbumCellIdentity = @"AlbumCellIdentity";
static NSString *kAlbumDetailViewControllerIdentity = @"AlbumDetailViewControllerIdentity";
static NSString *kSearchViewControllerIdentity = @"SearchViewControllerIdentity";


@interface AlbumViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver, UISearchBarDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewAlbum;
@property PHFetchResult *pHFetchResultAlbum;
@property PHImageManager *phImageManger;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property BOOL isEdit;

@property UIBarButtonItem *editBtn;
@property UIBarButtonItem *doneBtn;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end

@implementation AlbumViewController


#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isEdit = NO;
    
    self.phImageManger = [[PHImageManager alloc] init];
    
    self.collectionViewAlbum.delegate = self;
    self.collectionViewAlbum.dataSource = self;
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self.imageManager stopCachingImagesForAllAssets];
    
    self.pHFetchResultAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];

    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

    
    self.editBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_header_edit"] style:UIBarButtonItemStyleDone target:self action:@selector(handleEditButtonItem:)];
    self.doneBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_header_done"] style:UIBarButtonItemStyleDone target:self action:@selector(handleDoneButtonItem)];
    
    self.navigationItem.rightBarButtonItem = self.editBtn;
    
    self.tfSearch.delegate = self;
    
    //init searchbar
    self.searchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.title = NSLocalizedString(@"search_photo", @"");
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
- (void) searchPhoto : (NSString*)strSearch{
    SearchViewController *resultVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kSearchViewControllerIdentity];
    if ([strSearch length] > 0) {
        resultVC.strSearch = strSearch;
        [self.navigationController pushViewController:resultVC animated:YES];
    }else{
        [self.view makeToast:NSLocalizedString(@"no_input_text_to_search", @"")];
    }
}

- (IBAction)handleAddButtonItem:(id)sender {
    // Prompt user from new album title.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"new_album", @"") message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"album_name", @"");
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:NULL]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"create", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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

- (IBAction)handleEditButtonItem:(id)sender {
    self.isEdit = YES;
    [self.collectionViewAlbum reloadData];
    
    self.navigationItem.rightBarButtonItem = self.doneBtn;
}

- (void)handleDoneButtonItem{
    self.isEdit = NO;
    [self.collectionViewAlbum reloadData];
    
    self.navigationItem.rightBarButtonItem = self.editBtn;
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
      [collectionView dequeueReusableCellWithReuseIdentifier:kAlbumCellIdentity
                                                forIndexPath:indexPath];
    
    [cell initDelegate];

  PHAssetCollection *collection = self.pHFetchResultAlbum[indexPath.row];
    
    cell.collection = self.pHFetchResultAlbum[indexPath.row];

  cell.lbName.text = collection.localizedTitle;
    [cell.tfName setText:collection.localizedTitle];
    cell.btnDelete.tag = indexPath.row;
    
    if (collection.startDate) {
        cell.lbDate.text = [Utils date2str:collection.endDate onlyDate:NO];
    }else{
        cell.lbDate.text = @"Date: Unknown";
    }
    
    
    
    if(self.isEdit){
        cell.btnDelete.hidden = NO;
        [cell.tfName setEnabled:YES];
        [cell.editBtn setHidden:NO];
        
    }else{
        cell.btnDelete.hidden = YES;
        [cell.tfName setEnabled:NO];
        [cell.editBtn setHidden:YES];
    }

  PHFetchResult *assetsFetchResult =
      [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    
    cell.lbNumber.text = [NSString stringWithFormat:@"%d", [assetsFetchResult count]];

  PHAsset *lastAsset = [assetsFetchResult lastObject];
    
    // Request an image for the asset from the PHCachingImageManager.
    [self.imageManager requestImageForAsset:lastAsset
                                 targetSize:cell.imgAlbum.bounds.size
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  [cell.imgAlbum setImage:result];
                              }];
    
  return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isEdit) {
        return;
    }
    PHAssetCollection *collection = self.pHFetchResultAlbum[indexPath.row];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    
        AlbumDetailViewController *showVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kAlbumDetailViewControllerIdentity];
        if ([assetsFetchResult count] > 0) {
            showVC.fetchPhoto = assetsFetchResult;
            showVC.album = collection.localizedTitle;
            [self.navigationController pushViewController:showVC animated:YES];
        }else{
            [self.view makeToast:NSLocalizedString(@"album_empty", @"")
                        duration:3.0
                        position:CSToastPositionCenter
                           style:nil];
        }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat size = (w-30)/2.0;
    return CGSizeMake(size, size+50);
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchPhoto:searchBar.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchPhoto:textField.text];
    return YES;
}

@end
