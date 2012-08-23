//
//  ListViewController.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "PWListViewController.h"
#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKList.h>
#import <WeiboKit/WKStatus.h>
#import <WeiboKit/WKOAuthUser.h>
#import "PWStatusDetailViewController.h"

@interface PWListViewController ()
@end

@implementation PWListViewController


#pragma mark -
#pragma mark Pull To Refresh



- (void)start{
    
}

- (void)startWithList:(WKList *)list{
    if ([list.statuses count] > 0) {
        
        [self.results insertObjects:list.statuses
                          atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [list.statuses count])]];
        
        NSNumber *lastListItemID = [(WKStatus *)[list.statuses lastObject] idNumber];
        
        NSComparisonResult result = [[list next_cursor] compare:lastListItemID];
        if (result == NSOrderedSame) {
            //remove the "load statuses" string
            
            NSLog(@"%@",[self.results objectAtIndex:[list.statuses count]]);
            if ([[self.results objectAtIndex:[list.statuses count]] isKindOfClass:[NSString class]]) {
                [self.results removeObjectAtIndex:[list.statuses count]];
            }
        }
        else if (result == NSOrderedAscending){
            // Still need the "load statuses string"
            // Or we need to add it!
            if (![[self.results objectAtIndex:[list.statuses count]] isKindOfClass:[NSString class]]) {
                NSLog(@"Add Load More at Index %d", [list.statuses count]);
                [self.results insertObject:@"Load More" atIndex:[list.statuses count]];
            }
        }
        
        [self.tableView reloadData];
    }
    NSLog(@"Finished HomeTimelineList start");
    [self finishLoading];
}

- (void)refreshData{
    [self performSelector:@selector(finishLoading) withObject:nil afterDelay:1.0];
}

- (void)refreshDataWithList:(WKList *)list{
    if ([list.statuses count] > 0) {
        
        [self.results insertObjects:list.statuses
                          atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [list.statuses count])]];
        
        NSLog(@"%@",[list next_cursor]);
        NSLog(@"%@",[(WKStatus *)[list.statuses lastObject] idNumber]);
        
        [self.tableView reloadData];
    }
    [self finishLoading];
}

- (void)loadFromMiddleWithSince:(WKStatus *)since andMax:(WKStatus *)max atIndexPath:(NSIndexPath *)indexpath{
    
}

- (void)loadFromMiddleWithList:(WKList *)list withSince:(WKStatus *)since andMax:(WKStatus *)max atIndexPath:(NSIndexPath *)indexpath{
    
    //remove loading
    [self.results removeObjectAtIndex:indexpath.row];
    
    
    //Add The new Statuses
    if ([list.statuses count] > 0) {
        
        
        
        NSRange range = NSMakeRange(indexpath.row, [list.statuses count]);
        
        [self.results insertObjects:list.statuses
                          atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        
    }
    
    //Check if We need to add More again
    NSNumber *lastListItemID = [(WKStatus *)[list.statuses lastObject] idNumber];
    NSComparisonResult result = [[list next_cursor] compare:lastListItemID];
    if (result == NSOrderedSame) {
        // Finished No need to add the Cell
        
    }
    else if (result == NSOrderedAscending){
        // Add Back in the Load More Cell
        [self.results insertObject:@"Load More" atIndex:indexpath.row + [list.statuses count]];
    }
    
    [self.tableView reloadData];
    [self finishLoading];
    NSLog(@"Finished HomeTimelineList loadFromBottom");
}

- (void)loadFromBottom{
    [self performSelector:@selector(finishLoading) withObject:nil afterDelay:1.0];
}

- (void)loadFromBottomWithList:(WKList *)list{
    [self.results removeObject:[self.results lastObject]];
    [self.results addObjectsFromArray:list.statuses];
    [self.results addObject:@"Load More"];
    [self.tableView reloadData];
    [self finishLoading];
    NSLog(@"Finished HomeTimelineList loadFromBottom");
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    self.pullToRefreshView = view;
    [view startLoading];
    [self refreshData];
}

- (void)finishLoading{
    [self.pullToRefreshView performSelector:@selector(finishLoading) withObject:nil afterDelay:1.0];
}

- (void)failedOperation:(AFHTTPRequestOperation *)operation withError:(NSError *)error{
    NSLog(@"Error fetching statuses!");
    NSLog(@"%@", error);
    [self finishLoading];
}

- (id)init{
    if ((self = [super init])){
        _results = [NSMutableArray arrayWithObject:@"Load More"];
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
    NSLog(@"Reloading with results %d", [self.results count]);
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
    
    NSObject *cellData = [self.results objectAtIndex:indexPath.row];

    
    if ([cellData isKindOfClass:[NSString class]]) {
        // Load Old
        cell.textLabel.text = (NSString *)cellData;
    }
    else if ([cellData isKindOfClass:[WKStatus class]]){
        cell.textLabel.text = [(WKStatus *)cellData text];
    }

    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *cellData = [self.results objectAtIndex:indexPath.row];

    if (indexPath.row == [self.results count] - 1) {
        NSLog(@"Load from Bottom");
        cellData = @"Loading...";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = (NSMutableString *)cellData;
        [self loadFromBottom];
    }
    else{
        if ([cellData isKindOfClass:[NSString class]]) {
           
            cellData = @"Loading...";
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = (NSMutableString *)cellData;
            
            WKStatus *previous = [self.results objectAtIndex:(indexPath.row - 1)];
            WKStatus *next = [self.results objectAtIndex:(indexPath.row + 1)];
            
            [self loadFromMiddleWithSince:next andMax:previous atIndexPath:indexPath];
            
        }
        else if ([cellData isKindOfClass:[WKStatus class]]){
            // Show a detail view of the tweet here
            NSLog(@"%@",cellData);
            PWStatusDetailViewController *detail = [[PWStatusDetailViewController alloc] initWithStatus:(WKStatus *)cellData];
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}

@end
