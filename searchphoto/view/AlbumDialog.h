//
//  AlbumDialog.h
//  Searchphoto
//
//  Created by paraline on 1/15/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFAlbumDialogListener.h"

@interface AlbumDialog : UIView <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tbAlbum;

@property id<IFAlbumDialogListener> listener;

@property (strong, nonatomic) NSMutableArray *arrayPHAssetCollection;

+ (instancetype)sharedInstance;

- (void) initDelegate;

@end
