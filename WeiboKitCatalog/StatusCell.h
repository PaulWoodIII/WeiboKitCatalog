//
//  StatusCell.h
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/20/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKStatus;

@interface StatusCell : UITableViewCell

+(CGFloat)cellHeightForStatus:(WKStatus*)post;
-(void)setStatus:(WKStatus*)post;

@end
