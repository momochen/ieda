//
//  LoginViewController.m
//  ieda
//
//  Created by Yu Chen on 8/20/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import "LoginViewController.h"
#import "UserProfile.h"
#import "SesarAPI.h"
#import "DataFormViewController.h"
#import "SampleData.h"

@interface LoginViewController ()

@end


@implementation LoginViewController
@synthesize responseData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userName.delegate = self;
    self.password.delegate = self;
    SampleData* sd = [SampleData sharedInstance];
    
}
- (IBAction)loginPressed:(id)sender {
    
    NSString* username = self.userName.text;
    NSString* password = self.password.text;
    //username: sesartest@gmail.com password:registersamples
    if ([username length]==0) {
        username = @"sesartest@gmail.com";
        password = @"registersamples";
    }
    
    NSLog(@"Username:%@, Password:%@",username,password);
    
    NSString* userAuthenticationAddr = @"http://app.geosamples.org/webservices/credentials_service.php";
    
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:userAuthenticationAddr]];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
        responseData = [NSMutableData data];
    } else {
        NSLog(@"Connection could not be made");
    }
    
}

- (IBAction)registerPressed:(id)sender {
    // Go to the other Regsiter UI
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@\n", error.description);
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Got response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reponse body is %@",responseBody);
    
    if (YES) {
        // Push to new UI
        // Do any additional setup after loading the view.
       
        
        [[UserProfile sharedInstance] setUsername:self.userName.text];
        [[UserProfile sharedInstance] setPassword:self.password.text];
        [[UserProfile sharedInstance] setAuthenticated:true];
        
        //Go to data uploading UI
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DataformViewController *dataVC = [storyboard instantiateViewControllerWithIdentifier:@"DataformViewController"];
        NSMutableArray* requiredAttributes = [[NSMutableArray alloc] init];
        NSMutableArray* optionalAttributes = [[NSMutableArray alloc] init];
        for (id key in [[SampleData sharedInstance] sampleDataTemplateDict]) {
            
            if ([[[[SampleData sharedInstance] sampleDataTemplateDict] objectForKey:key] objectForKey:@"required"]) {
                [requiredAttributes addObject:(NSString*)key];
            }else{
                [optionalAttributes addObject:(NSString*)key];
            }
        }
        [dataVC setRequiredAttributes:requiredAttributes];
        [dataVC setOptionalAttributes:optionalAttributes];
        
        [dataVC setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:dataVC animated:YES];
    }
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[responseData length]);
    NSString *str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
