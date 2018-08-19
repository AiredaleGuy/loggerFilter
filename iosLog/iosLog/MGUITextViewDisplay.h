//
//  MGTextViewDisplay.h
//  iosLog
//
//  Created by Matthijs Gates on 8/18/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MGLogger/MGLogger.h>

@interface textViewDisplay : NSObject<MGDisplayDelegate>
- (instancetype) __unavailable init;
- (instancetype) initWithTextView:(UITextView *)tv;

//    MGDisplayDelegate methods
- (void) appendLine:(NSMutableAttributedString *)line;
- (NSAttributedString *) getContent;
- (void) clear;
- (NSMutableAttributedString *) highlightSearchRange:(NSRange)range inString:(NSMutableAttributedString *)string;

@end
