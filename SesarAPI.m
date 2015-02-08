//
//  SesarAPI.m
//  ieda
//
//  Created by Yu Chen on 8/28/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import "SesarAPI.h"

@implementation SesarAPI
@synthesize userAuthenticationAddr;
@synthesize sampleRegistrationAddr;
@synthesize mutData;

static SesarAPI *_sharedInstance;

-(id) init{
    if (self = [super init]){
        userAuthenticationAddr = @"http://app.geosamples.org/webservices/credentials_service.php";
        sampleRegistrationAddr = @"http://app.geosamples.org/webservices/uploadservice.php";
    }
    
    return self;
}

+ (SesarAPI *) sharedInstance{
    if (!_sharedInstance){
        _sharedInstance = [[SesarAPI alloc] init];
    }
    
    return _sharedInstance;
}

- (BOOL) authenticateUser:(NSString*)username withPassword:(NSString*)password{
    
    NSString *post = [NSString stringWithFormat:@"&username=%@&password=%@",username,password];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:userAuthenticationAddr]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }

    return true;
}

- (BOOL) registerData:(NSDictionary *)dataform withUsername:(NSString *)username Password:(NSString *)password{
    
    return true;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"Received data");
    [mutData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Received response");
    [mutData setLength:0];
    NSLog(@"%@\n", response.description);
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Failed with error");
    NSLog(@"%@\n", error.description);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[mutData length]);
    NSString *str = [[NSString alloc] initWithData:mutData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
}


@end
