//
//  PWStatusDetailViewController.h
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/23/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSLabel.h>
#import "TTTAttributedLabel.h"

@class WKStatus;

@interface PWStatusDetailViewController : UIViewController {
    
}

@property (nonatomic, assign) IBOutlet UITextView *textView;
@property (nonatomic, assign) IBOutlet UIImageView *userImageView;

- (id)initWithStatus:(WKStatus *)status;

@end
