//
//  RootViewController.h
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/15/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKAuthorize.h"

@interface RootViewController : UITableViewController <WKAuthorizeDelegate> {
    
}

@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) WKAuthorize *authorize;

@end
