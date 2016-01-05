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
}
- (IBAction)saveImage:(id)sender {
    NSLog(@"[ShowPhotoViewController] saveImage() %@", self.urlImage);
    
    NSData *data = [NSData dataWithContentsOfURL:self.urlImage];
    UIImage *image = [UIImage imageWithData:data scale:1.0];
    
}


@end
