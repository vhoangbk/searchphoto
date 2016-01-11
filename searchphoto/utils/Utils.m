//
//  Utils.m
//  Searchphoto
//
//  Created by Hoang Nguyen on 1/4/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "Utils.h"

@import Photos;

@implementation Utils

+ (NSString *)createRandomName{
    NSTimeInterval timeStamp = [ [ NSDate date ] timeIntervalSince1970 ];
    NSString *randomName = [ NSString stringWithFormat:@"M%f", timeStamp];
    randomName = [ randomName stringByReplacingOccurrencesOfString:@"." withString:@"" ];
    return randomName;
}

+(void)makeAlbumWithTitle:(NSString *)title onSuccess:(void(^)(NSString *AlbumId))onSuccess onError: (void(^)(NSError * error)) onError

{
    
    //Check weather the album already exist or not
    
//    if (![self getMyAlbumWithName:title]) {
    
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            // Request editing the album.
            
            PHAssetCollectionChangeRequest *createAlbumRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
            // Get a placeholder for the new asset and add it to the album editing request.
            
            PHObjectPlaceholder * placeHolder = [createAlbumRequest placeholderForCreatedAssetCollection];
            
            if (placeHolder) {
                
                onSuccess(placeHolder.localIdentifier);
                
            }
        } completionHandler:^(BOOL success, NSError *error) {
            
            NSLog(@"Finished adding asset. %@", (success ? @"Success" : error));
            
            if (error) {
                onError(error);
            }
            
        }];
        
//    }
    
}

+(void)addNewAssetWithImage:(UIImage *)image toAlbum:(PHAssetCollection *)album onSuccess:(void(^)(NSString *ImageId))onSuccess onError: (void(^)(NSError * error)) onError

{
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        // Request creating an asset from the image.
        
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        // Request editing the album.
        
        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        
        // Get a placeholder for the new asset and add it to the album editing request.
        
        PHObjectPlaceholder * placeHolder = [createAssetRequest placeholderForCreatedAsset];
        
        [albumChangeRequest addAssets:@[ placeHolder ]];
        NSLog(@"%@",placeHolder.localIdentifier);
        
        if (placeHolder) {
            
            onSuccess(placeHolder.localIdentifier);
            
        }
    } completionHandler:^(BOOL success, NSError *error) {
        
        NSLog(@"Finished adding asset. %@", (success ? @"Success" : error));
        
        if (error) {
            
            onError(error);
            
        }
        
    }];
    
}

+(NSArray *)getAssets:(PHFetchResult *)fetch
{
    __block NSMutableArray * assetArray = NSMutableArray.new;
    [fetch enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        NSLog(@"asset:%@", asset);
        [assetArray addObject:asset];
    }];
    return assetArray;
}

//+ (void)getImageWithIdentifier:(NSString*)imageId onSuccess:(void(^)(UIImage *image))onSuccess onError: (void(^)(NSError * error)) onError
//
//{
//    
//    NSError *error = [[NSError alloc] init];
//    
//    PHFetchResult *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[imageId] options:nil];
//    
//    if (assets.count == 0) onError(error);
//    NSArray * assetArray = [self getAssets:assets];
//    
//    PHImageManager *manager = [PHImageManager defaultManager];
//    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    
//    [manager requestImageForAsset:assetArray.firstObject targetSize:screenRect.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        
//        onSuccess(result);
//    }];
//}

@end
