//
//  ViewController.m
//  macLog
//
//  Created by Matthijs Gates on 8/17/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import "ViewController.h"
#import "MGNSTextViewDisplay.h"

@implementation ViewController
{
	__unsafe_unretained IBOutlet NSTextView *	_logDisplay;
	MGContentSource *							_content;
    textViewDisplay *                           _tvDisplay;
    MGLogger *                                  _logger;
    __weak IBOutlet NSButton *                  _bFilter;
    __weak IBOutlet NSTextField *               _tfSearch;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    _tvDisplay = [[textViewDisplay alloc] initWithTextView:_logDisplay];
    
    _bFilter.state = NSControlStateValueOff;
    
    [_tfSearch setDelegate:self];
    
    _logger = [[MGLogger alloc] init];
    [_logger setDisplayDelegate:_tvDisplay];
    [_logger searchFor:nil filterDisplay:([_bFilter state] == NSControlStateValueOn)];

	_content = [[MGContentSource alloc] init];
	[_content setDelegate:self];
	[_content start:100];
}

- (IBAction)onFilterClicked:(id)sender {
    [self refreshSearch];
}
	
- (void) refreshSearch {
    NSString * searchString = ([_tfSearch.stringValue length] > 0 ? _tfSearch.stringValue : nil);
    [_logger searchFor:searchString filterDisplay:([_bFilter state] == NSControlStateValueOn)];
}

//  called when search text is done being updated
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    if (control == _tfSearch) {
        [self refreshSearch];
    }
    
    return YES;
}

- (void) emit:(NSString *)string {
	[_logger logString:string];
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}


@end
