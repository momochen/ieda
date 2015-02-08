//
//  DataformViewController.m
//  ieda
//
//  Created by Yu Chen on 8/28/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import "DataformViewController.h"
#import "SingleAttributeViewController.h"
#import "ConfirmationViewController.h"
#import "SampleData.h"

@interface DataformViewController ()

@end

@implementation DataformViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.attributesTableView deselectRowAtIndexPath:self.attributesTableView.indexPathForSelectedRow animated:YES]; // For some reason the tableview does not do it automatically
    
    [self.attributesTableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.attributesTableView.dataSource = self;
    self.attributesTableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *simpleTableIdentifier = [@"AttributeTableCell:" stringByAppendingString:[NSString stringWithFormat:@"%lu,%lu",indexPath.section,indexPath.row]];
    
    if ([indexPath section]<2) {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }else {
            for (UIView* tempView in cell.contentView.subviews) {
                [tempView removeFromSuperview];
            }
        }
        
        if ([indexPath section]==0) {
            cell.textLabel.text =[self.requiredAttributes objectAtIndex:indexPath.row];
            
            if ([[[SampleData sharedInstance] currentEditData] objectForKey:cell.textLabel.text]!=nil && [[[[SampleData sharedInstance] currentEditData] objectForKey:cell.textLabel.text] length]>0) {
                //Being edited before, therefore put a checkmark there
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 40, 40)];
                imageView.image = [UIImage imageNamed:@"checkmark.png"];
                [cell.contentView addSubview:imageView];
            }
            
        }
        else if ([indexPath section]==1){
            cell.textLabel.text =[self.optionalAttributes objectAtIndex:indexPath.row];
            if ([[[SampleData sharedInstance] currentEditData] objectForKey:cell.textLabel.text]!=nil && [[[[SampleData sharedInstance] currentEditData] objectForKey:cell.textLabel.text] length]>0) {
                //Being edited before, therefore put a checkmark there
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 40, 40)];
                imageView.image = [UIImage imageNamed:@"checkmark.png"];
                [cell.contentView addSubview:imageView];
            }
            
            
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = @"Done";
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.section<2) {
        SingleAttributeViewController *singleVC = [storyboard instantiateViewControllerWithIdentifier:@"SingleAttributeViewController"];
        if ([indexPath section]==0) {
            singleVC.attributeLabelVal = [NSString stringWithFormat:@"%@",[self.requiredAttributes objectAtIndex:indexPath.row]];
            
            if([[self.requiredAttributes objectAtIndex:indexPath.row] rangeOfString:@"date"].location!=NSNotFound){
                //Date picker view
                singleVC.attributeType = @"date";
            }else if ([[[[SampleData sharedInstance] sampleDataTemplateDict] objectForKey:[self.requiredAttributes objectAtIndex:indexPath.row]] objectForKey:@"valList"]) {
                if ([[[[[[SampleData sharedInstance] sampleDataTemplateDict] objectForKey:[self.requiredAttributes objectAtIndex:indexPath.row]] objectForKey:@"valList"] objectAtIndex:0] length]>1) {
                    //Enums
                    NSLog(@"Enums");
                    singleVC.attributeType = @"enum";
                }
                else{
                    
                    //Nothing restriction, therefore just textfield
                    NSLog(@"Plain text");
                    singleVC.attributeType = @"text";
                }
            }else{
                //Nothing restriction, therefore just textfield
                NSLog(@"Plain text");
                singleVC.attributeType = @"text";
            }
        }else if([indexPath section]==1){
            singleVC.attributeLabelVal = [NSString stringWithFormat:@"%@",[self.optionalAttributes objectAtIndex:indexPath.row]];
            if([[self.optionalAttributes objectAtIndex:indexPath.row] rangeOfString:@"date"].location!=NSNotFound){
                NSLog(@"Date picker");
                //Date picker view
                singleVC.attributeType = @"date";
            }else if ([[[[SampleData sharedInstance] sampleDataTemplateDict] objectForKey:[self.optionalAttributes objectAtIndex:indexPath.row]] objectForKey:@"valList"]) {
                
                if ([[[[[[SampleData sharedInstance] sampleDataTemplateDict] objectForKey:[self.optionalAttributes objectAtIndex:indexPath.row]] objectForKey:@"valList"] objectAtIndex:0] length]>1) {
                    //Enums
                    NSLog(@"Enums");
                    singleVC.attributeType = @"enum";
                }
                else{
                    //Nothing restriction, therefore just textfield
                    NSLog(@"Plain text");
                    singleVC.attributeType = @"text";
                }
            }else{
                //Nothing restriction, therefore just textfield
                NSLog(@"Plain text");
                singleVC.attributeType = @"text";
            }
            
            
        }
        [singleVC setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:singleVC animated:YES completion:nil];
        
    }else{
        NSLog(@"Data done");
        
        // Push to sending queue
        
        [[SampleData sharedInstance] doneEditingCurrent];
        
        ConfirmationViewController* confirmVC = [storyboard instantiateViewControllerWithIdentifier:@"ConfirmationViewController"];
        [confirmVC setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:confirmVC animated:YES completion:nil];
        
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Required fields";
    }else if(section==1){
        return @"Optional fields";
    }else
        return @"Submit";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return [self.requiredAttributes count];
    }else if(section==1){
        return [self.optionalAttributes count];
    }else
        return 1;
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
