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
#import <WeiboKit/WKList.h>

@implementation PaulWoodTimelineList

- (void)start{
    // Lets show PaulWoods Statuses
    NSNumber *paulwood = [NSNumber numberWithLongLong:2214553562];
    
    [[WKOAuth2Client sharedInstance] getUserTimeline:paulwood withSuccess:^(WKList *list) {
        self.results = list.statuses;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching statuses!");
        NSLog(@"%@", error);
    }];
}

@end
