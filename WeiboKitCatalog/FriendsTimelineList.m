//
//  FriendsTimelineList.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "FriendsTimelineList.h"
#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKStatus.h>

@implementation FriendsTimelineList

- (void)start{
    // Lets show their Statuses
    [[WKOAuth2Client sharedInstance] getFriendsTimelineWithSuccess:^(NSMutableArray *statuses) {
        self.results = statuses;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching statuses!");
        NSLog(@"%@", error);
    }];
}

@end
