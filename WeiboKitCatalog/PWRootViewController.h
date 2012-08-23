//
//  RootViewController.h
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/15/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "SSPullToRefresh.h"

@class PWListViewController;

@interface PWRootViewController : UITableViewController <JTRevealSidebarV2Delegate, SSPullToRefreshViewDelegate> {
    
}

@end
