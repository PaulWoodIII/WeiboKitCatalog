//
//  HomeTimelineList.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "HomeTimelineList.h"
#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKList.h>
#import <WeiboKit/WKStatus.h>

@interface HomeTimelineList ()

@end

@implementation HomeTimelineList

- (void)loadFromBottom{
    
    NSLog(@"loadFromBottom HomeTimelineList");
    
    [[WKOAuth2Client sharedInstance] getHomeTimelineSinceStatus:nil
                                              withMaximumStatus:[self.cursors lastObject]
                                                          count:25
    withSuccess:^(WKList *list) {
        if ([list.statuses count] > 0) {
            
            [self.results addObjectsFromArray:list.statuses];
            [self.tableView reloadData];
        }
        [self updateCursorArrayWithList:list];
        [self finishLoading];
        NSLog(@"Finished HomeTimelineList loadFromBottom");
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error fetching HomeTimelineList statuses! loadFromBottom");
            NSLog(@"%@", error);
            [self finishLoading];
    }];
}


- (void)refreshData{
    
    NSLog(@"Refreshing HomeTimelineList");
    
    [[WKOAuth2Client sharedInstance] getHomeTimelineSinceStatus:[self.cursors objectAtIndex:0]
                                                          count:25

    withSuccess:^(WKList *list) {
        if ([list.statuses count] > 0) {
            
            [self.results insertObjects:list.statuses
                              atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [list.statuses count])]];
            [self.tableView reloadData];
        }
        [self updateCursorArrayWithList:list];
        [self finishLoading];
        NSLog(@"Finished HomeTimelineList refreshData");
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching HomeTimelineList statuses! refreshData");
        NSLog(@"%@", error);
        [self finishLoading];
    }];
}


- (void)start{
    // Lets show their Statuses
    [[WKOAuth2Client sharedInstance] getHomeTimelineWithSuccess:^(WKList *list) {
        self.results = list.statuses;
        [self updateCursorArrayWithList:list];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching statuses!");
        NSLog(@"%@", error);
    }];
}


@end
