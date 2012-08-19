//
//  ListViewController.h
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPullToRefresh.h"

@class WKList;
@class WKStatus;
@class AFHTTPRequestOperation;

@interface ListViewController : NSObject <UITableViewDataSource, UITableViewDelegate, SSPullToRefreshViewDelegate>

@property BOOL loading;
@property (nonatomic, assign) SSPullToRefreshView *pullToRefreshView;
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) NSMutableArray *cursors;
@property (nonatomic, retain) UITableView *tableView;

- (void)start;
- (void)startWithList:(WKList *)list;
- (void)refreshData;
- (void)refreshDataWithList:(WKList *)list;
- (void)loadFromMiddleWithSince:(WKStatus *)since andMax:(WKStatus *)max atIndexPath:(NSIndexPath *)indexpath;
- (void)loadFromMiddleWithList:(WKList *)list withSince:(WKStatus *)since andMax:(WKStatus *)max atIndexPath:(NSIndexPath *)indexpath;
- (void)loadFromBottom;
- (void)loadFromBottomWithList:(WKList *)list;
- (void)finishLoading;
- (void)failedOperation:(AFHTTPRequestOperation *)operation withError:(NSError *)error;

@end
