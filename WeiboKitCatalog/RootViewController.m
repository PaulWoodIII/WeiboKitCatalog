//
//  RootViewController.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/15/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "RootViewController.h"
#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKStatus.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.results = nil;
    
    WKAuthorize *auth = [[WKAuthorize alloc] initWithAppKey:@"" appSecret:@""];
    [auth setDelegate:self];
    [auth setRedirectURI:@"http://"];
    self.authorize = auth;
    [self.authorize startAuthorize];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = self.tableView.backgroundColor;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.backgroundColor = cell.contentView.backgroundColor;
        cell.detailTextLabel.backgroundColor = cell.textLabel.backgroundColor;
    }
    
    WKStatus *status = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = [status text];
    return cell;
}



- (void)authorize:(WKAuthorize *)authorize didSucceedWithAccessToken:(NSString *)accessToken
           userID:(NSString *)userID
        expiresIn:(NSInteger)seconds{
    [[WKOAuth2Client sharedInstance] setOauthToken:accessToken];
    [[WKOAuth2Client sharedInstance] getHomeTimelineWithSuccess:^(NSMutableArray *statuses) {
        self.results = statuses;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching beers!");
        NSLog(@"%@", error);
    }];
}

- (void)authorize:(WKAuthorize *)authorize didFailWithError:(NSError *)error{
    
}


@end
