//
//  UserProfile.m
//  ieda
//
//  Created by Yu Chen on 8/28/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile
@synthesize username;
@synthesize password;
@synthesize authenticated;

static UserProfile *_sharedInstance;

- (id) init{
    if (self = [super init]) {
        username = @"";
        password = @"";
        authenticated = false;
    }
    return self;
}

+ (UserProfile*) sharedInstance{
    if (!_sharedInstance) {
        _sharedInstance = [[UserProfile alloc] init];
    }
    
    return _sharedInstance;
}

- (BOOL)validUser{
    if (authenticated) {
        return true;
    }
    return false;
}


@end
