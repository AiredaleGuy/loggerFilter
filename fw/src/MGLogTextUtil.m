//
//  MGLogTextUtil.m
//  logText
//
//  Created by Matthijs Gates on 8/7/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import "MGLoggerPriv.h"

static NSAttributedStringKey MGLogText_SearchMatchNumber = @"MGLogText_SearchMatchNumber";

@implementation MGLogTextUtil

+ (void) setSearchMatchNumbers:(NSUInteger)numMatches inLine:(NSMutableAttributedString *)line {
	if (numMatches > 0) {
		[line addAttribute:MGLogText_SearchMatchNumber value:[NSNumber numberWithUnsignedInteger:numMatches] range:NSMakeRange(0, line.length)];
	}
	else {
		[line removeAttribute:MGLogText_SearchMatchNumber range:NSMakeRange(0, line.length)];
	}
}

+ (NSUInteger) getNumberSearchMatchesInLine:(NSMutableAttributedString *)line {
	assert(line);
	NSUInteger matches = 0;
	if (line.length > 0) {
		NSRange range = {0};
		id number = [line attribute:MGLogText_SearchMatchNumber atIndex:0 effectiveRange:&range];
		if (number != nil && [number isKindOfClass:[NSNumber class]]) {
			NSNumber * results = number;
			matches = [results unsignedIntegerValue];
		}
	}
	
	return matches;
}

@end

@implementation MGSubstringPredicate
- (instancetype) initWithSubstring:(NSString *)substring {
	self = [super init];
	if (self) {
		_substring = substring;
		_predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", _substring];
	}
	
	return self;
}

- (bool) isContainedInString:(NSString *)s {
	if (s && s.length > 0) {
		return [self.predicate evaluateWithObject:s];
	}
	
	return false;
}

@end
