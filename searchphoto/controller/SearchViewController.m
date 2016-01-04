//
//  TopViewController.m
//  searchphoto
//
//  Created by Hoang Nguyen on 1/4/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultViewController.h"

@interface SearchViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *tfSearch;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title = @"Search Photo";
    self.tfSearch.delegate = self;
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
//    [self.view endEditing:YES];
    [self.tfSearch resignFirstResponder];
}


@end
