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


@interface SearchViewController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewAlbum;
@property (strong, nonatomic) NSArray *arrayAlbum;

@end

@implementation SearchViewController


#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tfSearch.delegate = self;
    
    self.collectionViewAlbum.delegate = self;
    self.collectionViewAlbum.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKey];
    self.arrayAlbum = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];

    [self.collectionViewAlbum reloadData];
    
    self.navigationItem.title = @"Search Photo";
    
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
    return [self.arrayAlbum count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumIdentity"
                                                                       forIndexPath:indexPath];
    cell.lbName.text = [self.arrayAlbum objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKey];
    NSString *album = [path stringByAppendingPathComponent:[self.arrayAlbum objectAtIndex:indexPath.row]];
    
    NSArray *listImage = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:album error:nil];

    ShowPhotoAlbumViewController *showVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShowPhotoAlbumViewControllerIdentity"];
    if ([listImage count] > 0) {
        showVC.path = album;
        showVC.album = [self.arrayAlbum objectAtIndex:indexPath.row];
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
