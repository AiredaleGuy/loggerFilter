//
//  MGLogger.h
//  logText
//
//  Created by Matthijs Gates on 8/4/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MGLogger/MGDisplay.h>


@interface MGLogger : NSObject
@property (atomic, weak) id<MGDisplayDelegate> displayDelegate;

- (void) logString:(NSString *)string;
- (void) clear;
- (void) searchFor:(NSString *)search filterDisplay:(BOOL)filter;
@end
