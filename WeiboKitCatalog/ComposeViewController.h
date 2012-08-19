//
//  ComposeViewController.h
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/19/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface ComposeViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate>

@property BOOL isKeyboardShowing;

@property (nonatomic, retain) UIImagePickerController *imagePickerController; // the camera custom overlay view

@property BOOL cursorMovesToStart;

@property (nonatomic, retain) IBOutlet UIButton *atButton;
@property (nonatomic, retain) IBOutlet UIButton *hashButton;

@property (nonatomic, retain) NSString *postText;
@property (nonatomic, retain) IBOutlet UITextView  *statusTextView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sendButton;
@property (nonatomic, retain) IBOutlet UILabel *characterCountLabel;

@end
