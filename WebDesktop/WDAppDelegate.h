//
//  WDAppDelegate.h
//  WebDesktop
//
//  Created by Tae Won Ha on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class WDWindow;

@interface WDAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet WDWindow *window;
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSMenu *statusMenu;

- (IBAction)toggleBackground:(id)sender;

@end
