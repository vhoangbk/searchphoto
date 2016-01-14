//
//  AlbumDetailPhotoViewController.h
//  Searchphoto
//
//  Created by Hoang Nguyen on 1/15/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@import Photos;

@interface AlbumDetailPhotoViewController : BaseViewController

@property NSIndexPath *currentIndex;

@property PHFetchResult *resultCollection;


@end
