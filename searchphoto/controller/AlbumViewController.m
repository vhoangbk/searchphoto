//
//  AlbumViewController.m
//  Searchphoto
//
//  Created by paraline on 1/6/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "AlbumViewController.h"
#import "ImageViewCell.h"
#import "ShowPhotoAlbumViewController.h"
#import "TGRImageViewController.h"

@interface AlbumViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionPhoto;

@property (strong, nonatomic) NSArray *cellColors;

@end

@implementation AlbumViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionPhoto registerClass:[ImageViewCell class] forCellWithReuseIdentifier:@"ImagePhotoIdentity"];
    
    self.cellColors = @[ [UIColor colorWithRed:166.0f/255.0f green:201.0f/255.0f blue:227.0f/255.0f alpha:1.0],
                         [UIColor colorWithRed:227.0f/255.0f green:192.0f/255.0f blue:166.0f/255.0f alpha:1.0] ];
    
    self.collectionPhoto.dataSource = self;
    self.collectionPhoto.delegate = self;
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
    cell.imageView.backgroundColor = self.cellColors[indexPath.row % [self.cellColors count]];

    PHAsset *asset = [self.fetchPhoto objectAtIndex:indexPath.row];
    [[PHImageManager defaultManager] requestImageForAsset:asset
                  targetSize:cell.bounds.size
                 contentMode:PHImageContentModeAspectFill
                     options:nil
               resultHandler:^(UIImage *result, NSDictionary *info) {
                   [cell.imageView setImage:result];

               }];

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    ShowPhotoAlbumViewController *showVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShowPhotoAlbumViewControllerIdentity"];
//    showVC.currentIndex = indexPath.row;
//    NSMutableArray *images = [[NSMutableArray alloc] init];
//    
//    [self.fetchPhoto enumerateObjectsUsingBlock:^(PHAsset*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//                options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
//                options.synchronous = YES;
//                [[PHImageManager defaultManager] requestImageDataForAsset:obj options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//                    if (imageData) {
//                        [images addObject:[UIImage imageWithData:imageData]];
//                    }
//                }];
//            }];
//    
//    showVC.arrayImages = images;
//    [self.navigationController pushViewController:showVC animated:YES];
    

    
    ImageViewCell *cell = (ImageViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:cell.imageView.image];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat size = (w-30)/2.0;
    return CGSizeMake(size, size);
}

@end
