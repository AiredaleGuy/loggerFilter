//
//  MGLogger.m
//  logText
//
//  Created by Matthijs Gates on 8/4/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import "MGLoggerPriv.h"

static BOOL searchStringsDifferent(NSString * s1, NSString * s2) {
    return ((!!s1 != !!s2) ||   //  toggled
            ((s1 != nil && s2 != nil) && [s1 caseInsensitiveCompare:s2] != NSOrderedSame) ? TRUE : FALSE);
}

@implementation MGLogger
{
    NSString *  			_search;
    BOOL        			_filter;
	MGSubstringPredicate * 	_searchPredicate;
	
	//	when the display is being filtered, we need to keep a copy of all the content for when the
	//	  filtering goes off
    NSString * 				_contentCache;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _search = nil;
        _searchPredicate = nil;
        _filter = FALSE;
        _contentCache = nil;
    }
    
    return self;
}

//  this method is called when the filter or search string is updated and the displayed
//    content must be changed - search results highlighted or filtered lines displayed or
//    not displayed
- (void) refreshDisplayWithCompleteLogLocked:refreshContent {
    //  assert(locked)
	if (refreshContent) {
		[[self displayDelegate] clear];
		[self logStringInternal:refreshContent];
	}
}

- (void) logAttributedLine:(NSMutableAttributedString *)line {
	assert(line);
	[[self displayDelegate] appendLine:line];
}

- (void) logLinefeed {
	[self logAttributedLine:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
}

//	returns an array of ranges that are matches to the search string in the whole string
- (NSArray<NSString *> *) rangesOf:(NSString *)search inString:(NSString *)whole {
	NSMutableArray * ranges = [NSMutableArray array];
	if (search && whole) {
		NSRange wholeRange = NSMakeRange(0, whole.length);
		for (;;) {
			//  search
			NSRange r = [whole rangeOfString:search options:NSCaseInsensitiveSearch range:wholeRange];
			
			//  if not found, we are done
			if (r.location == NSNotFound) {
				break;
			}

			//	save the match for returning
			[ranges addObject:NSStringFromRange(r)];
			
			//  advance our range to beyond the match
			wholeRange.location = r.location + r.length;
			wholeRange.length = whole.length - wholeRange.location;
		}
	}
	
	return ranges;
}

//
- (NSMutableAttributedString *) highlightSubstrings:(NSString *)substring inLine:(NSMutableAttributedString *)line {
	NSArray * ranges = [self rangesOf:substring inString:line.string];
	for (NSString * range in ranges) {
		[[self displayDelegate] highlightSearchRange:NSRangeFromString(range) inString:line];
	}

	[MGLogTextUtil setSearchMatchNumbers:ranges.count inLine:line];
	assert([MGLogTextUtil getNumberSearchMatchesInLine:line] == ranges.count);
	
	return line;
}

//	TODO: use the predicate everywhere or don't use it at all -- we use it only to figure if we have
//	  hits (could use: 1) predicate with block
- (NSMutableAttributedString *) applyLineSearch:(NSMutableAttributedString *)line {
	if (line != nil && line.length > 0  && _searchPredicate) {
		if ([_searchPredicate.predicate evaluateWithObject:line.string]) {
			line = [self highlightSubstrings:_searchPredicate.substring inLine:line];
		}
	}
	
	return line;
}

- (NSMutableAttributedString *) applyFilter:(NSMutableAttributedString *)line {
    if (_search != nil && _filter) {
        if ([MGLogTextUtil getNumberSearchMatchesInLine:line] > 0) {
            return line;
        }
        else {
            return nil;
        }
    }
    else {
        return line;
    }
}

- (NSMutableAttributedString *) searchLine:(NSMutableAttributedString *)line {
    if (_search != nil) {
		return [self applyLineSearch:line];
    }
    else {
        return line;
    }
}

- (void) logLine:(NSString *)line {
    NSMutableAttributedString * attributedLine = [self applyFilter:[self searchLine:[[NSMutableAttributedString alloc] initWithString:line]]];
    if (attributedLine) {
        [self logAttributedLine: attributedLine];
        [self logLinefeed];
    }
}

- (void) logStringInternal:(NSString *)string {
    assert(string != nil);
    //  assert(locked)
    if (string.length > 0) {
        //  may need to break it up into individual lines
        [string enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
            [self logLine:line];
        }];
    }
    else {
        //  empty string
        [self logLine:string];
    }
}

- (void) updateContentCache:(NSString *)string {
    assert(string != nil);

	//	only
	if (_contentCache != nil) {
		_contentCache = [_contentCache stringByAppendingString:[string stringByAppendingString:@"\n"]];
	}
}

//	MARK: public instance methods

- (void) logString:(NSString *)string {
    if (string == nil) { return; }
    
    @synchronized(self) {
        [self updateContentCache:string];
        [self logStringInternal:string];
    }
}

- (void) searchFor:(NSString *)search filterDisplay:(BOOL)filter {
	@synchronized(self) {
		BOOL filterChanged = (filter != _filter);
		BOOL searchChanged = searchStringsDifferent(search, _search);
		
		//	update our state
		_search = search;
		_searchPredicate = ([_search length] > 0 ? [[MGSubstringPredicate alloc] initWithSubstring:_search] : nil);
		_filter = filter;

        //  if either of these changed, we'll need to refresh
		if ((filterChanged && _search) || searchChanged) {
			NSString * wholeContent = _contentCache;
			if (!wholeContent) {
				//	copy it because it will/may disappear if the display is cleared
				wholeContent = [[_displayDelegate getContent].string copy];
			}
			
			[self refreshDisplayWithCompleteLogLocked:wholeContent];

            //  this is the only combo that requires us to start caching what's logged
            if (_filter && _search) {
                _contentCache = wholeContent;
            }
            else {
                //  all other combos don't require it - we use the display instead
                _contentCache = nil;
            }
		}
	}
}

- (void) clear {
	@synchronized(self) {
		_contentCache = (_contentCache != nil ? @"" : nil);
		[[self displayDelegate] clear];
	}
}

@end
