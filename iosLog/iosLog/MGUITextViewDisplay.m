//
//  MGTextViewDisplay.m
//  iosLog
//
//  Created by Matthijs Gates on 8/18/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import "MGUITextViewDisplay.h"

static UIColor * backgroundColor()      { return [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]; }
//static NSColor * prefixColor()          { return NSColor.lightGrayColor; }
static UIColor * searchColor()          { return UIColor.yellowColor; }
static UIColor * lineHighlightColor()   { return UIColor.redColor; }
//static UIColor * logFont()               { return [UIColor fontWithName:@"PTMono-Bold" size:11]; }

//static NSMutableAttributedString * applyFontToRange(UIColor * color, NSRange range, NSAttributedString * string) {
//    NSMutableAttributedString * as = [[NSMutableAttributedString alloc] initWithAttributedString:string];
//    [as addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
//
//    return as;
//}

//static NSMutableAttributedString * applyFont(UIFont * font, NSAttributedString *string) {
//    //return applyFontToRange(font, NSMakeRange(0, string.length), string);
//}

@implementation textViewDisplay
{
    __weak UITextView *         _tv;
    UIFont *                    _logFont;
}

- (instancetype) initWithTextView:(UITextView *)tv {
    self = [super init];
    if (self) {
        _tv = tv;
        //_logFont = logFont();
    }
    
    return self;
}
- (IBAction)onFilterToggled:(id)sender {
}

- (void) scrollToLastLine {
	[_tv scrollRangeToVisible:NSMakeRange(_tv.text.length, 0)];
}

//    MARK: CMGDisplayDelegate methods

- (void) writeLineOnMainThread:(NSMutableAttributedString *)line {
    //  this needs to happen on the UI thread
    assert([NSThread isMainThread]);
	[_tv.textStorage appendAttributedString:line];
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

- (void) appendLine:(NSMutableAttributedString *)line {
    [self writeLine:line];
    [self scrollToLastLine];
}

- (NSAttributedString *) getContent {
	return _tv.textStorage;
}

- (void) clear {
    if ([NSThread isMainThread]) {
		_tv.text = @"";
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
			self->_tv.text = @"";
        });
    }
}

- (NSMutableAttributedString *) highlightSearchRange:(NSRange)range inString:(NSMutableAttributedString *)string {
    [string addAttribute:NSBackgroundColorAttributeName value:searchColor() range:range];
    return string;
}

@end
