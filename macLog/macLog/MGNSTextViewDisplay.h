//
//  MGTextViewDisplay.h
//  logText
//
//  Created by Matthijs Gates on 8/4/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <MGLogger/MGLogger.h>

@interface textViewDisplay : NSObject<MGDisplayDelegate>
- (instancetype) __unavailable init;
- (instancetype) initWithTextView:(NSTextView *)tv;

//	MGDisplayDelegate methods
- (void) appendLine:(NSMutableAttributedString *)line;
- (NSAttributedString *) getContent;
- (void) clear;
- (NSMutableAttributedString *) highlightSearchRange:(NSRange)range inString:(NSMutableAttributedString *)string;

@end
