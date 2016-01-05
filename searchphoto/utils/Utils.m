//
//  Utils.m
//  Searchphoto
//
//  Created by Hoang Nguyen on 1/4/16.
//  Copyright © 2016 Hoang Nguyen. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)createRandomName{
    NSTimeInterval timeStamp = [ [ NSDate date ] timeIntervalSince1970 ];
    NSString *randomName = [ NSString stringWithFormat:@"M%f", timeStamp];
    randomName = [ randomName stringByReplacingOccurrencesOfString:@"." withString:@"" ];
    return randomName;
}

@end
