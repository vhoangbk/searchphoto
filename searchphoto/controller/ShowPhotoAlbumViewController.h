//
//  ShowPhotoAlbumViewController.h
//  Searchphoto
//
//  Created by paraline on 1/7/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@import Photos;

@interface ShowPhotoAlbumViewController : BaseViewController

@property NSMutableArray *arrayImages;

//@property PHFetchResult *fetchPhoto;
@property NSUInteger currentIndex;

@end
