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
#import "ShowPhotoAlbumViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@import Photos;


@interface SearchViewController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver>

@property (strong, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewAlbum;
@property (strong, nonatomic) NSMutableArray *arrayPHAssetCollection;
@property PHFetchResult *pHFetchResultAlbum;

@end

@implementation SearchViewController


#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tfSearch.delegate = self;
    
    self.collectionViewAlbum.delegate = self;
    self.collectionViewAlbum.dataSource = self;
    
    self.arrayPHAssetCollection = [[NSMutableArray alloc] init];
    
    self.pHFetchResultAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    [self.pHFetchResultAlbum enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayPHAssetCollection addObject:obj];
    }];

    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                        style:UIBarButtonItemStyleDone target:self action:@selector(handleAddButtonItem)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.title = @"Search Photo";
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.arrayPHAssetCollection removeAllObjects];
        self.pHFetchResultAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        [self.pHFetchResultAlbum enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayPHAssetCollection addObject:obj];
        }];
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
    return [self.arrayPHAssetCollection count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumIdentity"
                                                                       forIndexPath:indexPath];
    
    PHAssetCollection *collection = self.arrayPHAssetCollection[indexPath.row];
    
    cell.lbName.text = collection.localizedTitle;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKey];
//    NSString *album = [path stringByAppendingPathComponent:[self.arrayAlbum objectAtIndex:indexPath.row]];
//    
//    NSArray *listImage = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:album error:nil];
//
//    ShowPhotoAlbumViewController *showVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShowPhotoAlbumViewControllerIdentity"];
//    if ([listImage count] > 0) {
//        showVC.path = album;
//        showVC.album = [self.arrayAlbum objectAtIndex:indexPath.row];
//        [self.navigationController pushViewController:showVC animated:YES];
//    }else{
//        [self.view makeToast:@"Album empty"];
//    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat size = (w-30)/2.0;
    return CGSizeMake(size, size);
}


@end
