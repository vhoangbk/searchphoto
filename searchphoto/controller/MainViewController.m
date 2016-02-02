//
//  MainViewController.m
//  Photo Download
//
//  Created by Hoang Nguyen on 2/2/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "MainViewController.h"
@import Photos;

@interface MainViewController () <UITabBarControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
}

- (BOOL)checkAccessPhoto{
    if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
        return YES;
    }
    return NO;
}

- (void)alertViewWithMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Photo Download App does not have access to your photo, To enable access go to: iphone setting > privacy > photo > Photo Download" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){
    if ([self checkAccessPhoto]){
        return YES;
    }else{
        [self alertViewWithMessage];
        return NO;
    }
}





@end
