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


@interface ShowPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgPresent;

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
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKey];
    NSArray *albums = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (NSString *album in albums) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:album
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                           [self saveImageWithPath:[path stringByAppendingPathComponent:album]];
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

- (void)saveImageWithPath : (NSString*) path{
    NSString *filename = [[[self.urlImage absoluteString] componentsSeparatedByString:@"/"] lastObject];
    NSData *data = [NSData dataWithContentsOfURL:self.urlImage];
    NSString *filePath = [path stringByAppendingPathComponent:filename];
    [data writeToFile:filePath atomically:YES];
//    UIImage *image = [UIImage imageWithData:data scale:1.0];
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
