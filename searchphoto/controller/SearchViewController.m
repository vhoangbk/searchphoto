//
//  TopViewController.m
//  searchphoto
//
//  Created by Hoang Nguyen on 1/4/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultViewController.h"
#import "Const.h"
#import "Utils.h"
#import "AMAImageViewCell.h"


@interface SearchViewController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewAlbum;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tfSearch.delegate = self;
    
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKey];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSLog(@"path: %@, size:%d ", path, [array count]);
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"Search Photo";
}


- (IBAction)pressesSearchButton:(UIButton*)sender{
    ResultViewController *resultVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResultViewControllerIdentity"];
    NSString *strSearch = [self.tfSearch text];
    if ([strSearch length] > 0) {
        resultVC.strSearch = strSearch;
        [self.navigationController pushViewController:resultVC animated:YES];
    }else{
        NSLog(@"[SearchViewController] pressesSearchButton() text nil");
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self.tfSearch resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tfSearch resignFirstResponder];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AMAImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumIdentity"
                                                                       forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"[SearchViewController] didSelectItemAtIndexPath() %d", indexPath.row);
    
}


@end
