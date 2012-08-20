//
//  StatusCell.m
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/20/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "StatusCell.h"
#import <QuartzCore/QuartzCore.h>
#import <WeiboKit/WKStatus.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TTTAttributedLabel.h"
#import "NSAttributedString+heightforrect.h"



@interface StatusCell () <TTTAttributedLabelDelegate>

@property(weak) IBOutlet UIImageView			*userPhoto;
@property(weak) IBOutlet UIImageView			*thoughtBubbleBackImageView;
@property(weak) IBOutlet TTTAttributedLabel		*thoughtLabel;

@property(assign) CGFloat						labelHeight;

@end

@implementation StatusCell

+(NSAttributedString*)boldString:(NSString*)string
{
    CTFontRef font      = CTFontCreateWithName(CFSTR("HelveticaNeue-Medium"), 17.0, NULL);
    
    NSMutableAttributedString * returnString = [[NSMutableAttributedString alloc] initWithString:string];
    [returnString addAttribute:(id)kCTFontAttributeName
                         value:(__bridge id)font
                         range:NSMakeRange(0, string.length)];
    
    CFRelease(font);
    
    return returnString;
}

+(NSAttributedString*)normalString:(NSString*)string
{
    CTFontRef font      = CTFontCreateWithName(CFSTR("HelveticaNeue"), 16.0, NULL);
    
    NSMutableAttributedString * returnString = [[NSMutableAttributedString alloc] initWithString:string];
    [returnString addAttribute:(id)kCTFontAttributeName
                         value:(__bridge id)font
                         range:NSMakeRange(0, string.length)];
    
    CFRelease(font);
    
    return returnString;
}

+(NSAttributedString*)attributedStringForStatus:(NSString*)text andUsername:(NSString*)username
{
    NSMutableAttributedString * returnString = [[NSMutableAttributedString alloc] init];
    
	[returnString appendAttributedString:[StatusCell boldString:username]];
	[returnString appendAttributedString:[StatusCell normalString:@" "]];
	[returnString appendAttributedString:[StatusCell normalString:text]];
    
    return returnString;
}

+(CGFloat)cellHeightForStatusText:(NSString*)text withUsername:(NSString*)username
{
	CGFloat height = [[StatusCell attributedStringForStatus:text andUsername:username] heightForWidth:240.0];
	return MAX(10+height+3+16+10, 60);
}

-(void)awakeFromNib
{
	[super awakeFromNib];
    
	self.thoughtLabel.dataDetectorTypes = UIDataDetectorTypeLink;
    self.thoughtLabel.delegate = self;
    
	CALayer * l = self.userPhoto.layer;
    
    l.masksToBounds = YES;
    l.cornerRadius  = 3;
    l.borderWidth   = 1;
    l.borderColor   = [UIColor darkGrayColor].CGColor;
    
    UITapGestureRecognizer *_recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(userPhotoTapped:)];
    
    [self.userPhoto addGestureRecognizer:_recognizer];
    self.userPhoto.userInteractionEnabled = YES;
    
    
	UIImage * image = [UIImage imageNamed:@"post-thoughtbubble"];
    
	image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(23, 20, 20, 8)];
    
    self.thoughtBubbleBackImageView.image = image;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
	self.thoughtBubbleBackImageView.frame = CGRectMake(45, 5, 263, self.labelHeight+15);
	self.thoughtLabel.frame = CGRectMake(60, 10, 240, self.labelHeight);
    
}

-(void)setStatusText:(NSString*)statusText username:(NSString*)username pictureURL:(NSURL*)picURL
{
	NSAttributedString* attrText = [StatusCell attributedStringForStatus:statusText andUsername:username];
	self.thoughtLabel.text = attrText;
    
	self.labelHeight = [attrText heightForWidth:240];
    
	[self.userPhoto setImageWithURL:picURL];
}

+(CGFloat)cellHeightForStatus:(WKStatus*)post
{
	return 0;
}

-(void)setStatus:(WKStatus*)post
{
	
}

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"URL TAPPED: %@", url);
    [[UIApplication sharedApplication] openURL:url];
}

@end
