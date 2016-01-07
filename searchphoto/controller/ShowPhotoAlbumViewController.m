//
//  ShowPhotoAlbumViewController.m
//  Searchphoto
//
//  Created by paraline on 1/7/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "ShowPhotoAlbumViewController.h"
#import "UIPhotoGalleryView.h"


@interface ShowPhotoAlbumViewController () <UIPhotoGalleryDataSource>

@property (strong, nonatomic) IBOutlet UIPhotoGalleryView *galeryAlbum;

@end

@implementation ShowPhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.galeryAlbum.dataSource = self;

    self.galeryAlbum.initialIndex = self.currentIndex;
    self.galeryAlbum.showsScrollIndicator = YES;
    self.galeryAlbum.galleryMode = UIPhotoGalleryModeImageLocal;

    
    
}


#pragma UIPhotoGalleryDataSource methods
- (NSInteger)numberOfViewsInPhotoGallery:(UIPhotoGalleryView *)photoGallery {
    return [self.arrayImages count];
}

- (UIImage*)photoGallery:(UIPhotoGalleryView*)photoGallery localImageAtIndex:(NSInteger)index {
    return [self.arrayImages objectAtIndex:index];
}

@end
