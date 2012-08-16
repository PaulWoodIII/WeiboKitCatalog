//
//  ListViewController.h
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) UITableView *tableView;

- (void)start;

@end
