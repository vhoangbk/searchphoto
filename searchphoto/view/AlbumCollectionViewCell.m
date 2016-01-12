//
//  AlbumCollectionViewCell.m
//  Searchphoto
//
//  Created by Hoang Nguyen on 1/6/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "AlbumCollectionViewCell.h"

@implementation AlbumCollectionViewCell

- (IBAction)deleteAlbum:(id)sender {
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCollectionChangeRequest deleteAssetCollections:[NSArray arrayWithObject:self.collection]];
        
    } completionHandler:^(BOOL success, NSError *error) {
        NSLog(@"Finished removing the album");
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *changeTitlerequest =[PHAssetCollectionChangeRequest changeRequestForAssetCollection:(PHAssetCollection*)self.collection];
        changeTitlerequest.title = self.tfName.text;
    } completionHandler:^(BOOL success, NSError *error) {
        NSLog(@"Finished editing collection. %@", (success ? @"Successfully." : error));
    }];
    
};


@end
