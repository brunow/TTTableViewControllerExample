/*
 Copyright (c) 2011 Bruno Wernimont
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "TwitterSearchDataSource.h"

#import "TwitterSearchModel.h"

@implementation TwitterSearchDataSource

- (void)dealloc {
	TT_RELEASE_SAFELY(_twitterSearchModel);
	
	[super dealloc];
}

- (id)init {
	if (self = [super init]) {
		_twitterSearchModel = [[TwitterSearchModel alloc] init];
	}
	
	return self;
}

- (void)tableViewDidLoadModel:(UITableView *)tableView {
	NSMutableArray *objects = [[NSMutableArray alloc] init];
	
	[objects addObjectsFromArray:[_twitterSearchModel results]];
	
	TTTableMoreButton *button = [TTTableMoreButton itemWithText:@"Load more tweets"];
	[objects addObject:button];
	
	self.items = objects;
	[objects release];
}

- (id<TTModel>)model {
	return _twitterSearchModel;
}

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
	return [super tableView:tableView cellClassForObject:object];
}

- (NSString *)titleForLoading:(BOOL)reloading {
    return @"Loading...";
}

- (NSString *)titleForEmpty {
    return @"No tweet";
}

- (NSString *)titleForError:(NSError *)error {
    return @"Oops";
}


@end
