//
//  NSAttributedString+hyperlink.h
//  RedmineTimeTracker
//
//  Created by pfy on 31.01.13.
//  Copyright (c) 2013 smooh GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;
@end
