//
//  MGLogTextUtil.h
//  logText
//
//  Created by Matthijs Gates on 8/7/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGLogTextUtil : NSObject
+ (void) setSearchMatchNumbers:(NSUInteger)numMatches inLine:(NSMutableAttributedString *)line;
+ (NSUInteger) getNumberSearchMatchesInLine:(NSMutableAttributedString *)line;
@end

@interface MGSubstringPredicate : NSObject
@property (readonly) NSPredicate *  predicate;
@property (readonly) NSString *     substring;
- (instancetype) initWithSubstring:(NSString *)substring;
- (bool) isContainedInString:(NSString *)s;
@end

