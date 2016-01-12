//
//  AlbumCollectionViewCell.h
//  Searchphoto
//
//  Created by Hoang Nguyen on 1/6/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;

@interface AlbumCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgAlbum;

@property (nonatomic, weak) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UITextField *tfName;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (nonatomic, weak) IBOutlet UILabel *lbDate;

@property (nonatomic, weak) IBOutlet UILabel *lbNumber;

@property PHAsset *collection;

@property (strong, nonatomic) IBOutlet UIButton *editBtn;

@end
