//
//  RCViewController.m
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "RCViewController.h"
#import <SVProgressHUD.h>

@interface RCViewController ()

@end

@implementation RCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[[RCHTTPServer sharedServer] startServer];
    
    [self.view addSubview:({
        UILabel *addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, [RCToolKit fullScreenWidth] - 40, 30)];
        
        if ([RCHTTPServer sharedServer].isRunning) {
            [addrLabel setText:[RCHTTPServer sharedServer].serverURL];
        } else {
            [addrLabel setText:@"server is not running"];
        }
        
        [addrLabel.layer setBorderWidth:1];
        [addrLabel.layer setBorderColor:[UIColor darkGrayColor].CGColor];
        addrLabel;
    })];
    
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, [RCToolKit fullScreenWidth], [RCToolKit fullScreenHeight] - 60) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView;
    })];
    
    [self refreshTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"RCANoteHasBeenReceived" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_notes ? [_notes count] : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RCToolKit calculateTextHeight:[UIFont systemFontOfSize:17] givenText:((RCNote *)[_notes objectAtIndex:indexPath.row]).content givenWidth:[RCToolKit fullScreenWidth] - 30] + 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"noteCell";
    UITableViewCell *noteCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( !noteCell) {
        noteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [noteCell.textLabel setText:((RCNote *)[_notes objectAtIndex:indexPath.row]).content];
    [noteCell.textLabel setNumberOfLines:(NSInteger)pow(2, 10)];

    return noteCell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    RCNote *note = [_notes objectAtIndex:indexPath.row];
    pasteboard.string = note.content;
    NSInteger times = [note.times integerValue];
    [note setTimes:@( ++times)];
    [[RCDatabase sharedDatabase] updateNote:note];
    [SVProgressHUD showSuccessWithStatus:@"已复制！"];
}

#pragma mark - refresh

- (void)refreshTableView {
    _notes = [NSArray arrayWithArray:[[RCDatabase sharedDatabase] queryWithKey:@"date"]];
    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO ];
}
@end
