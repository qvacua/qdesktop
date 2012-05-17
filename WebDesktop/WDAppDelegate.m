//
//  WDAppDelegate.m
//  WebDesktop
//
//  Created by Tae Won Ha on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WDAppDelegate.h"
#import "WDWindow.h"

@interface WDAppDelegate ()
- (void)activateStatusMenu;
@end

@implementation WDAppDelegate {
    NSStatusItem *_statusItem;
}

@synthesize window = _window;
@synthesize webView = _webView;
@synthesize statusMenu = _statusMenu;

- (void)activateStatusMenu {
    NSStatusBar *bar = [NSStatusBar systemStatusBar];

    _statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];

    [_statusItem setTitle:@"😎"];
    [_statusItem setHighlightMode:YES];
    [_statusItem setMenu:self.statusMenu];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self activateStatusMenu];

//    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"file:///Volumes/Data/hat/.webdesktop/index.html"]]];
    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://icanhascheezburger.com/"]]];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    if ([menuItem action] == @selector(toggleBackground:)) {
        return YES;
    }

    return [super validateMenuItem:menuItem];
}

- (IBAction)toggleBackground:(id)sender {
    [self.window toggleDesktopBackground];
}

@end
