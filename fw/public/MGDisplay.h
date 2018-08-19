//
//  MGDisplay.h
//  logText
//
//  Created by Matthijs Gates on 8/4/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGDisplayDelegate
@required
- (void) appendLine:(NSMutableAttributedString *)line;
- (NSAttributedString *) getContent;
- (void) clear;
- (NSMutableAttributedString *) highlightSearchRange:(NSRange)range inString:(NSMutableAttributedString *)string;
@end
