//
//  ShowPhotoAlbumViewController.h
//  Searchphoto
//
//  Created by paraline on 1/6/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@import Photos;

@interface ShowPhotoAlbumViewController : BaseViewController


@property NSString *album;

@property PHFetchResult *fetchPhoto;

@end
