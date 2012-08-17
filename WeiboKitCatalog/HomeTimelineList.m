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

- (void)refreshData{
    
    [[WKOAuth2Client sharedInstance] getHomeTimelineSinceStatus:[self.results objectAtIndex:0]
                                                 startingAtPage:1
                                                          count:2

    withSuccess:^(WKList *list) {
        if ([list.statuses count] > 0) {
            [self.results insertObjects:list.statuses
                              atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [list.statuses count] - 1)]];
            [self.tableView reloadData];
        }
        [self finishLoading];

    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching statuses!");
        NSLog(@"%@", error);
        [self finishLoading];
    }];
}


- (void)start{
    // Lets show their Statuses
    [[WKOAuth2Client sharedInstance] getHomeTimelineWithSuccess:^(WKList *list) {
        self.results = list.statuses;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching statuses!");
        NSLog(@"%@", error);
    }];
}


@end
