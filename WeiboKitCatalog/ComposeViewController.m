//
//  ComposeViewController.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/19/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "ComposeViewController.h"
#import <WeiboKit/WKOAuth2Client.h>

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (id)init
{
    if ((self = [super initWithNibName:@"ComposeViewController" bundle:nil])) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObservers];
    [self.statusTextView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidLoad];
    [self removeObservers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendPressed:(id)sender{
    if ([self.statusTextView.text isEqualToString:@""])
    {
		return;
	}
    
    [[WKOAuth2Client sharedInstance] updateStatusWithComment:self.statusTextView.text
    withSuccess:^(WKStatus *status)
    {
        [self dismissPostStatusViewController:nil];
        NSLog(@"Status Added %@", status);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error Posting status!");
        NSLog(@"%@", error);
    }];
}

-(IBAction)hashPressed:(id)sender{
    [self.statusTextView insertText:@"#"];
}

-(IBAction)atPressed:(id)sender{
    [self.statusTextView insertText:@"@"];
}

-(IBAction)dismissPostStatusViewController:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Text Length
// Code modified but was original from Weibo's SDK 

- (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}

- (void)calculateTextLength
{
    if (self.statusTextView.text.length > 0)
	{
		[self.sendButton setEnabled:YES];
	}
	else
	{
		[self.sendButton setEnabled:NO];
	}
	
	int wordcount = [self textLength:self.statusTextView.text];
	NSInteger count  = 140 - wordcount;
	if (count < 0)
    {
		[self.characterCountLabel setTextColor:[UIColor redColor]];
		[self.sendButton setEnabled:NO];
		[self.sendButton setTintColor:[UIColor grayColor]];
	}
	else
    {
		[self.characterCountLabel setTextColor:[UIColor darkGrayColor]];
		[self.sendButton setEnabled:YES];
		[self.sendButton setTintColor:[UIColor blueColor]];
	}
	
	[self.characterCountLabel setText:[NSString stringWithFormat:@"%i",count]];
}


#pragma mark - UIKeyboardNotification Methods

- (void)keyboardWillShow:(NSNotification*)notification
{
    if (self.isKeyboardShowing)
    {
        return;
    }
	self.isKeyboardShowing = YES;    
}

- (void)keyboardWillHide:(NSNotification*)notification
{
	self.isKeyboardShowing = NO;
}

#pragma mark - UITextViewDelegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
	[self calculateTextLength];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

#pragma mark Observers

- (void)addObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIKeyboardWillShowNotification" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIKeyboardWillHideNotification" object:nil];
}




@end
