//
//  SingleAttributeViewController.h
//  ieda
//
//  Created by Yu Chen on 8/28/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleAttributeViewController : UIViewController<UITextViewDelegate,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *attributeLabel;
@property (strong, nonatomic) NSString* attributeLabelVal;
@property (nonatomic,copy) NSString* attributeType;
@property (nonatomic,retain) NSString* attributeVal;
@property (strong, nonatomic) IBOutlet UIButton *doneEditBtn;
@property (nonatomic,retain) IBOutlet UITextView* myTextView;
@property (nonatomic,retain) IBOutlet UIPickerView* myPickerView;
@property (nonatomic,retain) IBOutlet UIDatePicker* myDateView;

@end
