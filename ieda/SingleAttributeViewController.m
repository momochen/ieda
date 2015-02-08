//
//  SingleAttributeViewController.m
//  ieda
//
//  Created by Yu Chen on 8/28/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import "SingleAttributeViewController.h"
#import "SampleData.h"

@interface SingleAttributeViewController ()

@end

@implementation SingleAttributeViewController
@synthesize attributeLabel;
@synthesize attributeLabelVal;
@synthesize attributeType;
@synthesize attributeVal;
@synthesize myDateView;
@synthesize myTextView;
@synthesize myPickerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.attributeVal = @"";
    self.attributeLabel.text = self.attributeLabelVal;
    //NSLog(@"%@",[[[SampleData sharedInstance] currentEditData] description]);
    if ([attributeType isEqualToString:@"text"]) {
        // Textual edit field:
        myTextView = [[UITextView alloc] initWithFrame:CGRectMake(2, 150, 316, 200)];
        myTextView.delegate = self;
        [myTextView setEditable:YES];
        myTextView.layer.borderWidth = 2.0f;
        myTextView.layer.borderColor = [[UIColor blackColor] CGColor];
        // Load exisiting data if any
        if ([[[SampleData sharedInstance] currentEditData] objectForKey:attributeLabelVal]) {
            myTextView.text = [[[SampleData sharedInstance] currentEditData] objectForKey:attributeLabelVal];
        }
        [self.view addSubview:myTextView];
    }
    else if([attributeType isEqualToString:@"enum"]){
        // Picker field
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 150, 320, 200)];
        
        myPickerView.delegate = self;
        myPickerView.showsSelectionIndicator = YES;
        // Loading existing data if any
        if ([[[SampleData sharedInstance] currentEditData] objectForKey:attributeLabelVal]) {
            //NSLog(@"Before load selected? %@",[[[SampleData sharedInstance] currentEditData] objectForKey:attributeLabelVal]);
            //NSLog(@"Everything %@",[[[SampleData sharedInstance] sampleDataTemplateDict] objectForKey:attributeLabelVal]);
            NSInteger rowNum = [[[[[SampleData sharedInstance] sampleDataTemplateDict] objectForKey:attributeLabelVal] objectForKey:@"valList"] indexOfObject:[[[SampleData sharedInstance] currentEditData] objectForKey:attributeLabelVal]];
            [myPickerView selectRow:rowNum inComponent:0 animated:NO];
        }
        
        [self.view addSubview:myPickerView];
    }else if([attributeType isEqualToString:@"date"]){
        // Date field
        myDateView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 150, 320, 200)];
        // Load existing data if any
        if ([[[SampleData sharedInstance] currentEditData] objectForKey:attributeLabelVal]) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY/MM/dd-HH:mmZ"];
            NSDate* selectedDate = [formatter dateFromString:[[[SampleData sharedInstance] currentEditData] objectForKey:attributeLabelVal]];
            [myDateView setDate:selectedDate];
            
        }
        [self.view addSubview:myDateView];
        
    }
    
    
}
- (IBAction)back:(id)sender {
    // Save current data and go back to data form view
    if ([attributeType isEqualToString:@"text"]) {
        //Text
        attributeVal = [[self myTextView] text];
        
    }else if([attributeType isEqualToString:@"enum"]){
        //Enum
    }else if([attributeType isEqualToString:@"date"]){
        NSDate* selectedDate = [[self myDateView] date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY/MM/dd-HH:mmZ"];

        NSString *stringFromDate = [formatter stringFromDate:selectedDate];
        attributeVal = stringFromDate;
        
    }
    
    [[[SampleData sharedInstance] currentEditData] setValue:attributeVal forKey:self.attributeLabelVal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    attributeVal = [[[[[SampleData sharedInstance] sampleDataTemplateDict] objectForKey:self.attributeLabelVal] objectForKey:@"valList"] objectAtIndex:row];
    
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [[[[[SampleData sharedInstance] sampleDataTemplateDict] objectForKey:self.attributeLabelVal] objectForKey:@"valList"] count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[[[[SampleData sharedInstance] sampleDataTemplateDict] objectForKey:self.attributeLabelVal] objectForKey:@"valList"] objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

- (IBAction)doneEditing:(id)sender {
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
