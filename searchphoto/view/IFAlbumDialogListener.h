//
//  IFAlbumDialogListener.h
//  Searchphoto
//
//  Created by paraline on 1/15/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IFAlbumDialogListener <NSObject>

- (void) onCancel;

- (void) onSelected : (NSInteger) index;

@end
