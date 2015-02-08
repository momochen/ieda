//
//  DataformViewController.h
//  ieda
//
//  Created by Yu Chen on 8/28/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataformViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSMutableArray* attributesList;
@property (nonatomic,retain) NSMutableArray* requiredAttributes;
@property (nonatomic,retain) NSMutableArray* optionalAttributes;
@property (strong, nonatomic) IBOutlet UITableView *attributesTableView;

@end
