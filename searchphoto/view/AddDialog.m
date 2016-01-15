//
//  AddDialog.m
//  Searchphoto
//
//  Created by paraline on 1/15/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "AddDialog.h"

@implementation AddDialog

+ (instancetype)sharedInstance{
    return [[[NSBundle mainBundle] loadNibNamed:@"AddDialog" owner:self options:nil] lastObject];;
}

@end
