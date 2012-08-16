//
//  SidebarViewController.h
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/16/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SidebarViewController;

@protocol SidebarViewControllerDelegate <NSObject>

- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(SidebarViewController *)sidebarViewController;

@end

@interface SidebarViewController : UITableViewController

@property (nonatomic, assign) id <SidebarViewControllerDelegate> sidebarDelegate;

@end

