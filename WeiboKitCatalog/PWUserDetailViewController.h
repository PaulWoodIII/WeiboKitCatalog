//
//  PWUserDetailViewController.h
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/23/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKUser;

@interface PWUserDetailViewController : UIViewController

@property (nonatomic, retain) WKUser *user;
@property (nonatomic, assign) IBOutlet UITextView *textView;
@property (nonatomic, assign) IBOutlet UIImageView *userImageView;

- (id)initWithUser:(WKUser *)user;

@end
