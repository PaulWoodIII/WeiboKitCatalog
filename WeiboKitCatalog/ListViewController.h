//
//  ListViewController.h
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPullToRefresh.h"

@interface ListViewController : NSObject <UITableViewDataSource, UITableViewDelegate, SSPullToRefreshViewDelegate>

@property BOOL loading;
@property (nonatomic, assign) SSPullToRefreshView *pullToRefreshView;

@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) NSMutableArray *cursors;
@property (nonatomic, retain) UITableView *tableView;

- (void)start;
- (void)refreshData;
- (void)finishLoading;

@end
