//
//  MGContentSource.h
//  logText
//
//  Created by Matthijs Gates on 8/11/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGContentSourceDelegate
- (void) emit:(NSString *)string;
@end

@interface MGContentSource : NSObject
@property (readwrite, atomic, weak) id<MGContentSourceDelegate> delegate;
- (void) start:(NSTimeInterval) intervalMilliseconds;
- (void) stop;
@end
