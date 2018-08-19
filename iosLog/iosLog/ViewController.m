//
//  ViewController.m
//  iosLog
//
//  Created by Matthijs Gates on 8/18/18.
//  Copyright © 2018 Matthijs Gates. All rights reserved.
//

#import "ViewController.h"
#import "MGUITextViewDisplay.h"
#import <MGLogger/MGLogger.h>

@interface ViewController ()

@end

@implementation ViewController
{
    __weak IBOutlet UISearchBar *   _sbSearch;
    __weak IBOutlet UITextView *    _tvDisplay;
	__weak IBOutlet UISwitch *		_swFilter;
	
    MGContentSource *               _content;
	textViewDisplay *				_display;
	MGLogger *						_logger;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_swFilter.on = FALSE;
	
	_sbSearch.showsCancelButton = true;
	_sbSearch.showsSearchResultsButton = true;
	_sbSearch.delegate = self;
	
	_display = [[textViewDisplay alloc] initWithTextView:_tvDisplay];
	
	_logger = [[MGLogger alloc] init];
	_logger.displayDelegate = _display;
	[_logger searchFor:nil filterDisplay:_swFilter.on];
	
    _content = [[MGContentSource alloc] init];
    [_content setDelegate:self];
    [_content start:100];
}

- (void) refreshSearch:(NSString *)search {
	[_logger searchFor:search filterDisplay:_swFilter.on];
}

- (IBAction)onFilterToggled:(id)sender {
    NSString * searchString = (_sbSearch.text.length > 0 ? _sbSearch.text : nil);
    [self refreshSearch:searchString];
}

//	MARK: UISearchBar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString * searchString = (_sbSearch.text.length > 0 ? _sbSearch.text : nil);
    [self refreshSearch:searchString];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self refreshSearch:nil];
}

//	MARK: MGContentSource delegate methods

- (void) emit:(NSString *)string {
	[_logger logString:string];
}

@end
