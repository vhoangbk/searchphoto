//
//  AlbumCollectionViewCell.h
//  Searchphoto
//
//  Created by Hoang Nguyen on 1/6/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgAlbum;
@property (nonatomic, weak) IBOutlet UILabel *lbName;

@end
