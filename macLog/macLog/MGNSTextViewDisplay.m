//
//  MGTextViewDisplay.m
//  logText
//
//  Created by Matthijs Gates on 8/4/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import "MGNSTextViewDisplay.h"

static NSColor * backgroundColor()      { return [NSColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]; }
//static NSColor * prefixColor()          { return NSColor.lightGrayColor; }
static NSColor * searchColor()          { return NSColor.yellowColor; }
static NSColor * lineHighlightColor()   { return NSColor.redColor; }
static NSFont * logFont()               { return [NSFont fontWithName:@"PTMono-Bold" size:11]; }

static NSMutableAttributedString * applyFontToRange(NSFont * font, NSRange range, NSAttributedString * string) {
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    [as addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    
    return as;
}

static NSMutableAttributedString * applyFont(NSFont * font, NSAttributedString *string) {
    return applyFontToRange(font, NSMakeRange(0, string.length), string);
}

@implementation textViewDisplay
{
    __weak NSTextView * _tv;
    NSFont *            _logFont;
}

- (instancetype) initWithTextView:(NSTextView *)tv {
    self = [super init];
    if (self) {
        _tv = tv;
        _logFont = logFont();
    }
    
    return self;
}

//	MARK: CMGDisplayDelegate methods

- (void) writeLineOnMainThread:(NSMutableAttributedString *)line {
    //  this needs to happen on the UI thread
    assert([NSThread isMainThread]);
	[_tv.textStorage appendAttributedString:applyFont(_logFont, line)];
    
    [self scrollToLastLine];
}

- (void) writeLine:(NSMutableAttributedString *)s {
    if ([NSThread isMainThread]) {
        [self writeLineOnMainThread:s];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self writeLineOnMainThread:s];
        });
    }
}

- (void) scrollToLastLine {
    [_tv scrollRangeToVisible:NSMakeRange([[_tv string] length], 0)];
}

- (void) appendLine:(NSMutableAttributedString *)line {
	[self writeLine:line];
	[self scrollToLastLine];
}

- (NSAttributedString *) getContent {
    return _tv.textStorage;
}

- (void) clear {
    if ([NSThread isMainThread]) {
		_tv.string = @"";
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
			self->_tv.string = @"";
        });
    }
}

- (NSMutableAttributedString *) highlightSearchRange:(NSRange)range inString:(NSMutableAttributedString *)string {
	[string addAttribute:NSBackgroundColorAttributeName value:searchColor() range:range];
	return string;
}

@end
