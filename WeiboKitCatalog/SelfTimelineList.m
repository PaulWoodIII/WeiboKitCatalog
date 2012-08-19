//
//  SelfTimelineList.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "SelfTimelineList.h"
#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKList.h>
#import <WeiboKit/WKStatus.h>
#import <WeiboKit/WKOAuthUser.h>

@implementation SelfTimelineList

- (void)start{
    // Lets show PaulWoods Statuses
    
    WKOAuthUser *user = [WKOAuthUser currentUser];
    
    [[WKOAuth2Client sharedInstance] getUserTimeline:user.user_id withSuccess:^(WKList *list) {
        self.results = list.statuses;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching statuses!");
        NSLog(@"%@", error);
    }];
    
}


@end
