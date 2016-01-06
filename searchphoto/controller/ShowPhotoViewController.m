//
//  ShowPhotoViewController.m
//  Searchphoto
//
//  Created by paraline on 1/5/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+AFNetworking.h"
#import "Utils.h"
#import "Const.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"


@interface ShowPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPresent;
@property ALAssetsLibrary *assetsLibrary;

@end

@implementation ShowPhotoViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.title = self.imageTitle;
    
    [self.imgPresent setImageWithURL:self.urlImageThum];
}

#pragma mark - private method
- (IBAction)createAlbum:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:@""
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Username";
    }];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             UITextField *tf = [alert.textFields firstObject];
                             if ([tf.text length]>0) {
                                 [self createAlbumWithName:tf.text];
                             }
                         }];
    UIAlertAction* cancel = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)saveImage:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Select album"
                                  message:@""
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKey];
    NSArray *albums = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (NSString *album in albums) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:album
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                           [self saveImageWithPath:[path stringByAppendingPathComponent:album] : album];
                                                       }];
        [alert addAction:action];
    }
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (ALAssetsLibrary *)getAssetsLibrary
{
    if (self.assetsLibrary) {
        return self.assetsLibrary;
    }
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    return self.assetsLibrary;
}

- (void)saveImageWithPath : (NSString*) path : (NSString*) album{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *filename = [[[self.urlImage absoluteString] componentsSeparatedByString:@"/"] lastObject];
    NSData *data = [NSData dataWithContentsOfURL:self.urlImage];
    NSString *filePath = [path stringByAppendingPathComponent:filename];
    [data writeToFile:filePath atomically:YES];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    [[self getAssetsLibrary] saveImage:image toAlbum:album completion:^(NSURL *assetURL, NSError *error) {
        NSLog(@"completion %@", assetURL);
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}



- (void)createAlbumWithName : (NSString*) name{
    
    NSArray *paths = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKey];
    NSString *folder = [NSString stringWithFormat:@"%@/%@",paths,name];
    
    NSError * error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:folder
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error != nil) {
        [self.view makeToast:@"Creating album error"];
    }else{
        [self.view makeToast:[NSString stringWithFormat:@"Album %@ has created", name]];
    }
}


@end
