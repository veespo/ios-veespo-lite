//
//  VERSSParser.h
//  Veespo
//
//  Created by Alessio Roberto on 24/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VERSSParser : NSObject <NSXMLParserDelegate> {
    NSXMLParser * rssParser;
    NSMutableArray * stories;
    // a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	// it parses through the document, from top to bottom...
	// we collect and cache each sub-element value, and then save each item to our array.
	// we use these to track each current item, until it's ready to be added to the "stories" array
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;
}

@property (copy) void (^parseResult)(NSMutableArray *result);

- (void)parseXMLFileAtURL:(NSString *)URL;

@end
