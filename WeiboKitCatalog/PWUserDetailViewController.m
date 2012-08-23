//
//  PWUserDetailViewController.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/23/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "PWUserDetailViewController.h"
#import <WeiboKit/WKUser.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface PWUserDetailViewController ()

@end

@implementation PWUserDetailViewController

- (id)initWithUser:(WKUser *)user{
    self = [super initWithNibName:@"PWUserDetailViewController" bundle:nil];
    if (self) {
        // Custom initialization
        _user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.text = [self.user description];
    [self.userImageView setImageWithURL:[self.user profile_image_url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
