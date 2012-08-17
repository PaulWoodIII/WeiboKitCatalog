//
//  PaulWoodTimelineList.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "PaulWoodTimelineList.h"
#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKStatus.h>
#import <WeiboKit/WKUser.h>

@implementation PaulWoodTimelineList

- (void)start{
    // Lets show PaulWoods Statuses
    
    WKUser *paulwood = [[WKUser alloc] init];
    paulwood.user_id = @"2214553562";
    
    [[WKOAuth2Client sharedInstance] getUserTimeline:paulwood withSuccess:^(NSMutableArray *statuses) {
        self.results = statuses;
        [self.tableView reloadData];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching statuses!");
        NSLog(@"%@", error);
    }];
}

@end