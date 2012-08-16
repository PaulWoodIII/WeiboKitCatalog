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
#import <WeiboKit/WKOAuthUser.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)changedCurrentUser:(NSNotification *)note{
    WKOAuthUser *user = note.object;
    NSLog(@"%@",user);
}

- (void)authorizationSuccessful:(NSNotification *)note{
    NSLog(@"%@",note.object);
    if ([WKOAuthUser currentUser] == note.object) {
        // The Current User is the user that authorized!
        // Lets show their Statuses
        [[WKOAuth2Client sharedInstance] getHomeTimelineWithSuccess:^(NSMutableArray *statuses) {
            self.results = statuses;
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error fetching statuses!");
            NSLog(@"%@", error);
        }];
    }
}

- (void)authorizationFailure:(NSNotification *)note{
    NSLog(@"%@",note.object);
}

- (void)registerForNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedCurrentUser:) name:kWKCurrentUserChangedNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationSuccessful:) name:kWKAuthorizationSuccessfullNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationFailure:) name:kWKAuthorizationFailureNotificationName object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.results = nil;
    [self registerForNotifications];
    [[WKOAuth2Client sharedInstance] startAuthorization];
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

@end
