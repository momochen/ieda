//
//  LoginViewController.h
//  ieda
//
//  Created by Yu Chen on 8/20/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate,NSURLConnectionDataDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (nonatomic, retain) NSMutableData* responseData;

@end
