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

#import "TwitterSearchModel.h"


@implementation TwitterSearchModel

@synthesize results = _objects;

- (id)init {
	if (self = [super init]) {
		_objects = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	if (more) {
		_page++;
	} else {
		_page = 1;
		[_objects removeAllObjects];
	}
	
	NSString *url = [NSString stringWithFormat:@"http://search.twitter.com/search.json?lang=en&q=three20&rpp=5&page=%d", _page];
	
	TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
	request.cachePolicy = TTURLRequestCachePolicyNone;
	request.httpMethod = @"GET";
	request.response = [[[TTURLJSONResponse alloc] init] autorelease];
	[request send];
}

#pragma mark -
#pragma mark TTURLRequestDelegate

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
	
	NSDictionary *json = response.rootObject;
	
	TTTableImageItem *item;
	
	for (NSDictionary *tweet in [json objectForKey:@"results"]) {
		item = [TTTableImageItem itemWithText:[tweet objectForKey:@"text"]
									 imageURL:[tweet objectForKey:@"profile_image_url"]
										  URL:@"http://twitter.com"];
		
		[_objects addObject:item];
	}
	
	[super requestDidFinishLoad:request];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
	[self didFailLoadWithError:error];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_objects);
	
	[super dealloc];
}

@end
