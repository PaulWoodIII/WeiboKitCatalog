//
//  SelfTimelineList.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "SelfTimelineList.h"
#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKStatus.h>
#import <WeiboKit/WKOAuthUser.h>

@implementation SelfTimelineList

- (void)start{
    // Lets show PaulWoods Statuses
    
    WKOAuthUser *user = [WKOAuthUser currentUser];
    
    [[WKOAuth2Client sharedInstance] getUserTimeline:user withSuccess:^(NSMutableArray *statuses) {
        self.results = statuses;
        [self.tableView reloadData];
    }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 NSLog(@"Error fetching statuses!");
                                                 NSLog(@"%@", error);
                                             }];
}


@end