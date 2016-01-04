//
//  ResultViewController.m
//  Searchphoto
//
//  Created by Hoang Nguyen on 1/4/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "ResultViewController.h"
#import "MBProgressHUD.h"
#import "ImageSearching.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"[ResultViewController] viewDidLoad() %@", self.strSearch);
    
    [self loadImagesWithOffset:10];
    
}

- (id<ImageSearching>)activeSearchClient
{
    NSString *searchProviderString = [[NSUserDefaults standardUserDefaults] stringForKey:@"search_provider"];
    id<ImageSearching> sharedClient = [NSClassFromString(searchProviderString) sharedClient];
    NSAssert(sharedClient, @"Invalid class string from settings encountered");
    
    return sharedClient;
}

- (void)loadImagesWithOffset:(int)offset
{
    // Do not allow empty searches
    if ([self.strSearch isEqual:@""]) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    id<ImageSearching> imageSearching = [self activeSearchClient];
    [imageSearching findImagesForQuery:self.strSearch withOffset:offset success:^(NSURLSessionDataTask *dataTask, NSArray *imageArray) {
        NSLog(@"[ResultViewController] loadImagesWithOffset() success: %@", dataTask);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSLog(@"[ResultViewController] loadImagesWithOffset() failure: %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}



@end
