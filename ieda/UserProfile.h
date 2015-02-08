//
//  UserProfile.h
//  ieda
//
//  Created by Yu Chen on 8/28/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (nonatomic,retain) NSString* username;
@property (nonatomic,retain) NSString* password;
@property (nonatomic) BOOL authenticated;

+ (UserProfile *) sharedInstance;

-(BOOL)validUser;

@end
