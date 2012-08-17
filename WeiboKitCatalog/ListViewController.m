//
//  ListViewController.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "ListViewController.h"
#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKList.h>
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

#pragma mark - Cursor Logic

- (void)updateCursorArrayWithList:(WKList *)list{
    
//TODO: This is incomplete
    
    if (!self.cursors) {
        // Initialize the cursors
        NSNumber *top;
        NSNumber *bottom;
        
        if ([list.previous_cursor compare:[NSNumber numberWithInteger:0]] == NSOrderedSame && [list.statuses count] > 0) {
            top = [(WKStatus *)[list.statuses objectAtIndex:0] idNumber];
        }
        else if(list.previous_cursor){
            top = [list.previous_cursor copy];
        }
        
        // Your very last post was loaded?
        if ([list.next_cursor compare:[NSNumber numberWithInteger:0]] == NSOrderedSame && [list.statuses count] > 0) {
            bottom = [(WKStatus *)[list.statuses objectAtIndex:0] idNumber];
        }
        else if (list.next_cursor){
            bottom = [list.next_cursor copy];
        }
        
        self.cursors = [NSMutableArray arrayWithObjects:top, bottom, nil];
    }
    else{
        NSNumber *inc_previous_cursor = [list.previous_cursor copy];
        NSNumber *inc_next_cursor = [list.next_cursor copy];
        
        NSNumber *current_top = [self.cursors objectAtIndex:0];
        NSNumber *current_bottom = [self.cursors lastObject];
        
        if ([current_top compare:inc_previous_cursor] == NSOrderedAscending) {
            // New Top
            [self.cursors insertObject:inc_previous_cursor atIndex:0];
            [self.cursors removeObject:current_top];
        }
        
        if ([current_bottom compare:inc_next_cursor] == NSOrderedAscending) {
            // We are loading from the bottom
            [self.cursors removeObject:current_bottom];
            [self.cursors addObject:inc_next_cursor];
        }
    }
}

@end
