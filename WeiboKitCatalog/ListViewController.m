//
//  ListViewController.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "ListViewController.h"
#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKStatus.h>
#import <WeiboKit/WKOAuthUser.h>

@interface ListViewController ()
@end

@implementation ListViewController

#pragma mark -
#pragma mark Pull To Refresh

- (void)start{
    
}

- (void)finishLoading{
    [self.pullToRefreshView performSelector:@selector(finishLoading) withObject:nil afterDelay:1.0];
}

- (void)refreshData{
    [self performSelector:@selector(finishLoading) withObject:nil afterDelay:1.0];
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    self.pullToRefreshView = view;
    [view startLoading];
    [self refreshData];
}

- (id)init{
    if ((self = [super init])){
        _results = nil;
    }
    return self;
}

- (void)setTableView:(UITableView *)tableView{
    if(_tableView != tableView){
        _tableView = tableView;
        _tableView.dataSource = self;
        _tableView.delegate = self;
            
        [_tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = self.tableView.backgroundColor;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.backgroundColor = cell.contentView.backgroundColor;
        cell.detailTextLabel.backgroundColor = cell.textLabel.backgroundColor;
    }
    
    WKStatus *status = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = [status text];
    return cell;
}

@end
