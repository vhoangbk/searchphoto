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


@interface ShowPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgPresent;

@end

@implementation ShowPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.title = self.imageTitle;
    
    [self.imgPresent setImageWithURL:self.urlImageThum];
}

- (IBAction)createAlbum:(id)sender {
    NSLog(@"[ShowPhotoViewController] createAlbum()");
    
    NSString *nameAlbum = [Utils createRandomName];
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKey];
    [[NSFileManager defaultManager] createDirectoryAtPath:[path stringByAppendingPathComponent:nameAlbum] withIntermediateDirectories:YES attributes:nil error:NULL];
}
- (IBAction)saveImage:(id)sender {
    NSLog(@"[ShowPhotoViewController] saveImage() %@", self.urlImage);
    
    NSData *data = [NSData dataWithContentsOfURL:self.urlImage];
    UIImage *image = [UIImage imageWithData:data scale:1.0];
    
}

- (void)createAlbum{
    
    NSString *album = [Utils createRandomName];
    
    NSArray *paths = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKey];
    NSString *folder = [NSString stringWithFormat:@"%@/%@",paths,album];
    
    
    NSError * error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:folder
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error != nil) {
        NSLog(@"error creating directory: %@", error);
    }
}


@end
