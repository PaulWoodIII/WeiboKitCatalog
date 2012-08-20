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

+(CGFloat)cellHeightForStatusText:(NSString*)text withUsername:(NSString*)username;
-(void)setStatusText:(NSString*)postText username:(NSString*)username pictureURL:(NSURL*)picURL;

+(CGFloat)cellHeightForStatus:(WKStatus*)post;
-(void)setStatus:(WKStatus*)post;

@end
