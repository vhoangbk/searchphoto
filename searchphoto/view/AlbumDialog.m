//
//  AlbumDialog.m
//  Searchphoto
//
//  Created by paraline on 1/15/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "AlbumDialog.h"

@import Photos;

@implementation AlbumDialog

+ (instancetype)sharedInstance{
    return [[[NSBundle mainBundle] loadNibNamed:@"AlbumDialog" owner:self options:nil] lastObject];;
}

- (void) initDelegate{
    self.tbAlbum.dataSource = self;
    self.tbAlbum.delegate = self;
}

- (IBAction)pressCancel:(id)sender {
    if (self.listener) {
        [self.listener onCancel];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayPHAssetCollection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    PHAssetCollection *collection = [self.arrayPHAssetCollection objectAtIndex:indexPath.row];
    
    cell.textLabel.text = collection.localizedTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listener) {
        [self.listener onSelected:indexPath.row];
    }
}


@end
