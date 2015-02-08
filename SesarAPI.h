//
//  SesarAPI.h
//  ieda
//
//  Created by Yu Chen on 8/28/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SesarAPI : NSObject<NSURLConnectionDataDelegate>{
    NSString* userAuthenticationAddr;
    NSString* sampleRegistrationAddr;
    
}

+ (SesarAPI *) sharedInstance;

@property (nonatomic,retain) NSString* userAuthenticationAddr;
@property (nonatomic,retain) NSString* sampleRegistrationAddr;
@property (nonatomic,retain) NSMutableData* mutData;

- (BOOL) authenticateUser:(NSString*) username withPassword:(NSString*)password;
- (BOOL) registerData:(NSDictionary*) dataform withUsername:(NSString*)username Password:(NSString*)password;

@end
