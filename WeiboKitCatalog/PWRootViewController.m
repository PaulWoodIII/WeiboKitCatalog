//
//  RootViewController.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/15/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "PWRootViewController.h"

#import <WeiboKit/WKOAuth2Client.h>
#import <WeiboKit/WKStatus.h>
#import <WeiboKit/WKOAuthUser.h>
#import "SSKeychain.h"

#import "UIViewController+JTRevealSidebarV2.h"
#import "UINavigationItem+JTRevealSidebarV2.h"

#import "PWListViewController.h"
#import "PWComposeViewController.h"

@interface PWRootViewController ()

@property NSUInteger currentListIndex;
@property (nonatomic, retain) PWListViewController *currentList;
@property (nonatomic, retain) NSArray *listControllers;
@property (nonatomic, strong) UITableView *leftSidebarView;
@property BOOL loading;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

- (BOOL)isLoggedIn;
- (void)createListControllers;

@end

@implementation PWRootViewController

#pragma mark -
#pragma mark Pull To Refresh

- (void)refresh {
    
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refresh];
}

#pragma mark -
#pragma mark Sidebar

#pragma mark JTRevealSidebarDelegate

// This is an examle to configure your sidebar view through a custom UIViewController
- (UIView *)viewForLeftSidebar {
    // Use applicationViewFrame to get the correctly calculated view's frame
    // for use as a reference to our sidebar's view
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    UITableView *view = self.leftSidebarView;
    if ( ! view) {
        view = self.leftSidebarView = [[UITableView alloc] initWithFrame:CGRectZero];
        view.dataSource = self;
        view.delegate   = self;
    }
    view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    view.autoresizingMask =  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    return view;
}

// This is an examle to configure your sidebar view without a UIViewController
- (UIView *)viewForRightSidebar {
    return nil;
}

// Optional delegate methods for additional configuration after reveal state changed
- (void)didChangeRevealedStateForViewController:(UIViewController *)viewController {
    // Example to disable userInteraction on content view while sidebar is revealing
    if (viewController.revealedState == JTRevealedStateNo) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}

- (void)revealLeftSidebar:(id)sender {
    [self.navigationController toggleRevealState:JTRevealedStateLeft];
}


#pragma mark -
#pragma mark Auth

- (BOOL)isLoggedIn{
    if (nil == [WKOAuthUser currentUser] || [[WKOAuthUser currentUser].accessToken isEqualToString:@""]) {
        return NO;
    }
    else{
        return YES;
    }
}


- (void)login{
    [[WKOAuth2Client sharedInstance] startAuthorization];
}

- (void)logout{
    
    WKOAuthUser *user = [WKOAuthUser alloc];
    user.user_id = nil;
    user.accessToken = @"";
    [WKOAuthUser setCurrentUser:user];
    
    self.currentListIndex = 0;
    self.currentList = nil;
    
    [self setupUI];

}


- (void)changedCurrentUser:(NSNotification *)note{

}

- (void)authorizationSuccessful:(NSNotification *)note{
    if ([WKOAuthUser currentUser] == note.object) {
        [self setupUI];
    }
}

- (void)authorizationFailure:(NSNotification *)note{

}

- (void)registerForNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedCurrentUser:) name:kWKCurrentUserChangedNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationSuccessful:) name:kWKAuthorizationSuccessfullNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationFailure:) name:kWKAuthorizationFailureNotificationName object:nil];
}

- (void)setupUI{
    if ([self isLoggedIn]) {
        UIBarButtonItem *sideBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(revealLeftSidebar:)];
        [self.navigationItem setLeftBarButtonItem:sideBarButton animated:YES];
        
        UIBarButtonItem *postBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(post)];
        [self.navigationItem setRightBarButtonItem:postBarButton];
        
        [self sidebarTableView:self.leftSidebarView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentListIndex]];
    }
    else{
        UIBarButtonItem *loginBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(login)];
        [self.navigationItem setRightBarButtonItem:loginBarButton];
        
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
        
        self.pullToRefreshView = nil;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.currentList = nil;
    [self createListControllers];
    
    [self registerForNotifications];
    
    self.navigationItem.revealSidebarDelegate = self;
    
    [self setupUI];
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    self.pullToRefreshView = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftSidebarView) {
        return [self.listControllers count];
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        return [self selfTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else{ // if (tableView == self.leftSidebarView){
        return [self sidebarTableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)selfTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LoginCellIdentifier";
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
    
    cell.textLabel.text = @"Please Login";
    return cell;
}

- (UITableViewCell *)sidebarTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SidebarCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( ! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = cell.contentView.backgroundColor;
        cell.detailTextLabel.backgroundColor = cell.textLabel.backgroundColor;
    }
    NSDictionary *itemDescription = [self.listControllers objectAtIndex:indexPath.row];
    cell.textLabel.text = (NSString *)[itemDescription objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        [self selfTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else if (tableView == self.leftSidebarView){
        [self sidebarTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)selfTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)sidebarTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *listDescription = [self.listControllers objectAtIndex:indexPath.row];
    NSString *action = [listDescription objectForKey:@"action"];
    
    if ([action isEqualToString:@"logout"]) {
        [self logout];
    }
    else{
        Class class = NSClassFromString(action);
        
        if (![self.currentList isMemberOfClass:class]) {
            PWListViewController *list = [[class alloc] init];
            self.tableView.dataSource = nil;
            self.tableView.delegate = nil;
            list.tableView = self.tableView;
            list.navigationController = self.navigationController;
            [list start];
            self.currentList = list;
            [self.pullToRefreshView finishLoading];
            self.pullToRefreshView.delegate = self.currentList;
        }
    }
    
    [self.navigationController setRevealedState:JTRevealedStateNo];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:NO animated:YES];
}

#pragma mark -
#pragma mark The List Controllers

- (void)createListControllers{
    
    self.currentListIndex = 0;
    
    NSArray *list = [[NSArray alloc] initWithObjects:
                     [[NSDictionary alloc] initWithObjectsAndKeys: @"PWHomeTimelineList",@"action", @"Home Timeline", @"name", nil],
                     [[NSDictionary alloc] initWithObjectsAndKeys: @"PWSelfTimelineList",@"action", @"My Timeline", @"name", nil],
                     [[NSDictionary alloc] initWithObjectsAndKeys: @"PWFriendsTimelineList",@"action", @"Friends Timeline", @"name", nil],
                     [[NSDictionary alloc] initWithObjectsAndKeys: @"PWPaulWoodTimelineList",@"action", @"Pauls Timeline", @"name", nil],
                     [[NSDictionary alloc] initWithObjectsAndKeys: @"logout",@"action", @"Logout", @"name", nil],
                     nil];
    
    self.listControllers = list;
    
}

#pragma mark -
#pragma mark The Compose Controller and Posting

- (void)post{
    PWComposeViewController *composeView = [[PWComposeViewController alloc] init];
    [self presentViewController:composeView animated:YES completion:nil];
}

@end
