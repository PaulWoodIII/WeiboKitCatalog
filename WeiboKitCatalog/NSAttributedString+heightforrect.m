//
//  NSAttributedString+heightforrect.h
//  WeiboKitCatalog
//
//  Created by Paul Wood on 8/20/12.
//  Copyright (c) 2012 Paul Wood. All rights reserved.
//

#import "NSAttributedString+heightforrect.h"

#import <CoreText/CoreText.h>

@implementation NSAttributedString (heightforrect)

-(CGFloat)heightForWidth:(CGFloat)width
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self); 
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, 
                                                                        CFRangeMake(0, 0), 
                                                                        NULL, 
                                                                        CGSizeMake(width, CGFLOAT_MAX), 
                                                                        NULL);
    CFRelease(framesetter);
    return suggestedSize.height;
}

@end
