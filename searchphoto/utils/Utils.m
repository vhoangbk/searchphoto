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

+(NSString*)date2str:(NSDate*)myNSDateInstance onlyDate:(BOOL)onlyDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (onlyDate) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat: @"dd-MM-yyyy HH:mm"];
    }
    
    NSString *stringFromDate = [formatter stringFromDate:myNSDateInstance];
    return stringFromDate;
}

+ (void) showDoneKeyForKeyboard : (UITextField*)tf{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:tf action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolbar.items = [NSArray arrayWithObjects: flex, rightButton, nil];
    tf.inputAccessoryView = toolbar;
}

@end
