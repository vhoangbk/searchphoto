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

+(CGFloat)pixelToPoints2:(CGFloat)px {
    
    CGFloat pointsPerInch = 72.0; // see: http://en.wikipedia.org/wiki/Point%5Fsize#Current%5FDTP%5Fpoint%5Fsystem
    CGFloat scale = 1; // We dont't use [[UIScreen mainScreen] scale] as we don't want the native pixel, we want pixels for UIFont - it does the retina scaling for us
    float pixelPerInch; // aka dpi
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        pixelPerInch = 132 * scale;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        pixelPerInch = 163 * scale;
    } else {
        pixelPerInch = 160 * scale;
    }
    CGFloat result = px * pointsPerInch / pixelPerInch;
    
    return result;
}

+ (UIImage* )setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect{
    
    // tcv - temporary colored view
    UIView *tcv = [[UIView alloc] initWithFrame:rect];
    [tcv setBackgroundColor:backgroundColor];
    
    
    // set up a graphics context of button's size
    CGSize gcSize = tcv.frame.size;
    UIGraphicsBeginImageContext(gcSize);
    // add tcv's layer to context
    [tcv.layer renderInContext:UIGraphicsGetCurrentContext()];
    // create background image now
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    //    [tcv release];
    
}
@end
