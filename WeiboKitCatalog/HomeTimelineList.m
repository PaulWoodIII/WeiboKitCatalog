//
//  HomeTimelineList.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "HomeTimelineList.h"
#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKStatus.h>

@interface HomeTimelineList ()

@end

@implementation HomeTimelineList

- (void)refreshData{
    
    [[WKOAuth2Client sharedInstance] getHomeTimelineSinceStatus:[self.results objectAtIndex:0]
                                                 startingAtPage:1
                                                          count:2

    withSuccess:^(NSMutableArray *statuses) {
        
        if ([statuses count] > 0) {
            [self.results insertObjects:statuses
                              atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [statuses count] - 1)]];
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
    [[WKOAuth2Client sharedInstance] getHomeTimelineWithSuccess:^(NSMutableArray *statuses) {
        self.results = statuses;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching statuses!");
        NSLog(@"%@", error);
    }];
}


@end
