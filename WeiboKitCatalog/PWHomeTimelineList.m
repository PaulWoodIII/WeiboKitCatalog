//
//  HomeTimelineList.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "PWHomeTimelineList.h"
#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKList.h>
#import <WeiboKit/WKStatus.h>

@interface PWHomeTimelineList ()

@end

@implementation PWHomeTimelineList

- (void)loadFromBottom{
    // Load in data from the bottom of the timeline
    NSLog(@"loadFromBottom HomeTimelineList");
    
    WKStatus *max = [self.results objectAtIndex:([self.results count] - 2)];
    
    [[WKOAuth2Client sharedInstance] getHomeTimelineSinceStatus:nil
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
    NSLog(@"loadFromMiddleWithSince HomeTimelineList");
    
    [[WKOAuth2Client sharedInstance] getHomeTimelineSinceStatus:[since idNumber]
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
    NSLog(@"Refreshing HomeTimelineList");
    
    NSObject *topdata = [self.results objectAtIndex:0];
    WKStatus *topStatus;
    if ([topdata isKindOfClass:[NSString class]]) {
        // Load Old
    }
    else if ([topdata isKindOfClass:[WKStatus class]]){
        topStatus = (WKStatus *)topdata;
    }
    
    [[WKOAuth2Client sharedInstance] getHomeTimelineSinceStatus:[topStatus idNumber]
                                                          count:5

    withSuccess:^(WKList *list) {
        [self refreshDataWithList:list];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failedOperation:operation withError:error];
    }];
}


- (void)start{
    // start the timeline.
    // soon we will load in what data we already have from Core Data
    
    // Stub
    // for now we just create some fake data for testing
    /*
    WKStatus *fake1 = [[WKStatus alloc] init];
    fake1.text= @"Fake 1";
    fake1.idNumber = [NSNumber numberWithLongLong:3479052277477353];
    fake1.idString = @"3479052277477353";
    WKStatus *fake2 = [[WKStatus alloc] init];
    fake2.text= @"Fake 2";
    fake2.idNumber = [NSNumber numberWithLongLong:3479051277477353];
    fake2.idString = @"3479051277477353";
    self.results = [NSMutableArray arrayWithObjects: fake1, fake2, @"Load More", nil];
    
    NSMutableArray *cursorArray = [NSMutableArray arrayWithObjects:[fake1.idNumber copy], [fake2.idNumber copy], nil];
    self.cursors = cursorArray;
    
    [self.tableView reloadData];
     */
    // End of stub
    
    NSLog(@"starting HomeTimelineList");
    
    [[WKOAuth2Client sharedInstance]
     getHomeTimelineWithSuccess:^(WKList *list)
    {
        [self startWithList:list];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self failedOperation:operation withError:error];

    }];
}


@end
