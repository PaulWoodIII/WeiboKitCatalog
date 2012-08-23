//
//  PWStatusDetailViewController.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/23/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "PWStatusDetailViewController.h"
#import <WeiboKit/WKStatus.h>
#import <WeiboKit/WKUser.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "PWUserDetailViewController.h"

@interface PWStatusDetailViewController ()

@property (nonatomic, retain) WKStatus *status;

@end

@implementation PWStatusDetailViewController

- (id)initWithStatus:(WKStatus *)status{
    self = [super initWithNibName:@"PWStatusDetailViewController" bundle:nil];
    if (self) {
        // Custom initialization
        _status = status;
    }
    return self;
}

- (IBAction)profileImagePressed:(id)sender{
    PWUserDetailViewController *profile = [[PWUserDetailViewController alloc] initWithUser:self.status.user];
    [self.navigationController pushViewController:profile animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView.text = [self.status description];
    [self.userImageView setImageWithURL:[self.status.user profile_image_url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
