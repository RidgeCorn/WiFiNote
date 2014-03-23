//
//  RCViewController.h
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *notes;
@end
