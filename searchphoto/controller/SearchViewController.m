//
//  SearchViewController.m
//  Searchphoto
//
//  Created by Hoang Nguyen on 1/4/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "SearchViewController.h"
#import "MBProgressHUD.h"
#import "ImageSearching.h"
#import "ImageViewCell.h"
#import "ImageRecord.h"
#import "UIImageView+AFNetworking.h"
#import "SearchDetailViewController.h"
#import "TGRImageViewController.h"

static NSString *kImageViewCellIdentity = @"ImageViewCellIdentity";
static NSString *kSearchDetailViewControllerIdentity = @"SearchDetailViewControllerIdentity";

@interface SearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionImage;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation SearchViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"back", @"");
    
    
    self.collectionImage.dataSource = self;
    self.collectionImage.delegate = self;
    
    [self.collectionImage registerClass:[ImageViewCell class] forCellWithReuseIdentifier:kImageViewCellIdentity];
    
    [self loadImagesWithOffset:0];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = [NSString stringWithFormat:@"Search: %@", self.strSearch];
}

#pragma mark - private method
- (id<ImageSearching>)activeSearchClient
{
    id<ImageSearching> sharedClient = [NSClassFromString(@"AFBingAPIClient") sharedClient];
    NSAssert(sharedClient, @"Invalid class string from settings encountered");
    
    return sharedClient;
}

- (void)loadImagesWithOffset:(int)offset
{
    // Do not allow empty searches
    if ([self.strSearch isEqual:@""]) {
        return;
    }
    
    if (offset==0) {
        // Clear the images array and refresh the table view so it's empty
        [self.images removeAllObjects];
        [self.collectionImage reloadData];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    
    id<ImageSearching> imageSearching = [self activeSearchClient];
    [imageSearching findImagesForQuery:self.strSearch withOffset:offset success:^(NSURLSessionDataTask *dataTask, NSArray *imageArray) {

        if (offset == 0) {
            self.images = [NSMutableArray arrayWithArray:imageArray];
        } else {
            [self.images addObjectsFromArray:imageArray];
        }
        
        [self.collectionImage reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageViewCellIdentity
                                                                       forIndexPath:indexPath];
    
    ImageRecord *imageRecord = [self.images objectAtIndex:indexPath.row];
    
    [cell.imageView setImageWithURL:imageRecord.thumbnailURL placeholderImage:[UIImage imageNamed:@"folder"]];
    
    // Check if this has been the last item, if so start loading more images...
    if (indexPath.row == [self.images count] - 1) {
        [self loadImagesWithOffset:(int)[self.images count]];
    };
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.images count];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageRecord *imageRecord = [self.images objectAtIndex:indexPath.row];
   
    SearchDetailViewController *showVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kSearchDetailViewControllerIdentity];
    showVC.urlImageThum = imageRecord.thumbnailURL;
    showVC.urlImage = imageRecord.imageURL;
    showVC.imageTitle = imageRecord.title;
    
    [self.navigationController pushViewController:showVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat size = (w-30)/2.0;
    return CGSizeMake(size, size);
}


@end
