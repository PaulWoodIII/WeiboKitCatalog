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
#import <WeiboKit/WKList.h>

@implementation FriendsTimelineList


- (void)loadFromBottom{
    // Load in data from the bottom of the timeline
    NSLog(@"loadFromBottom Friends Timeline List");
    
    WKStatus *max = [self.results objectAtIndex:([self.results count] - 2)];
    
    [[WKOAuth2Client sharedInstance] getFriendsTimelineSinceStatus:nil
                                                 withMaximumStatus:[max idNumber]
                                                             count:5
    withSuccess:^(WKList *list)
    {
        [self loadFromBottomWithList:list];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self failedOperation:operation withError:error];
    }];
}

- (void)loadFromMiddleWithSince:(WKStatus *)since andMax:(WKStatus *)max atIndexPath:(NSIndexPath *)indexpath{
    //Load in data from the middle of their timeline
    NSLog(@"loadFromMiddleWithSince Friends Timeline List");
    
    [[WKOAuth2Client sharedInstance] getFriendsTimelineSinceStatus:[since idNumber]
                                                 withMaximumStatus:[max idNumber]
                                                             count:5
    withSuccess:^(WKList *list)
    {
     [self loadFromMiddleWithList:list withSince:since andMax:max atIndexPath:indexpath];
    }
                                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
     [self failedOperation:operation withError:error];
    }];
}


- (void)refreshData{
    // Refresh Data from the top of their timeline
    NSLog(@"Refreshing Friends Timeline List");
    
    NSObject *topdata = [self.results objectAtIndex:0];
    WKStatus *topStatus;
    if ([topdata isKindOfClass:[NSString class]]) {
        // Load Old
        return;
    }
    else if ([topdata isKindOfClass:[WKStatus class]]){
        topStatus = (WKStatus *)topdata;
    }
    
    [[WKOAuth2Client sharedInstance] getFriendsTimelineSinceStatus:[topStatus idNumber]
                                                          count:5
    withSuccess:^(WKList *list) {
        [self refreshDataWithList:list];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failedOperation:operation withError:error];
    }];
}


- (void)start{
    // Lets show their Statuses
    NSLog(@"starting Friends Timeline List");
    
    [[WKOAuth2Client sharedInstance] getFriendsTimelineWithSuccess:^(WKList *list)
    {
        [self startWithList:list];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self failedOperation:operation withError:error];
        
    }];
}

@end
