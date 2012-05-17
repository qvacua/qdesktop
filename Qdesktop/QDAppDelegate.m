#import "QDAppDelegate.h"
#import "QDWindow.h"
#import "WebView+QDZoom.h"

static NSString *const DEFAULT_URL_KEY = @"url";
static NSString *const DEFAULT_URL_VALUE = @"http://www.hataewon.com";

@interface QDAppDelegate ()
- (void)initStatusMenu;
@end

@implementation QDAppDelegate {
    NSStatusItem *_statusItem;
}

@synthesize window = _window;
@synthesize webView = _webView;
@synthesize statusMenu = _statusMenu;
@synthesize urlWindow = _urlWindow;
@synthesize urlField = _urlField;

- (void)initStatusMenu {
    NSStatusBar *bar = [NSStatusBar systemStatusBar];

    _statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];

    [_statusItem setTitle:@"😎"];
    [_statusItem setHighlightMode:YES];
    [_statusItem setMenu:self.statusMenu];
}

- (void)setDefaultsIfNecessary {
    NSUserDefaults *const userDefaults = [NSUserDefaults standardUserDefaults];

    if ([userDefaults objectForKey:DEFAULT_URL_KEY] == nil) {
        [userDefaults setObject:DEFAULT_URL_VALUE forKey:DEFAULT_URL_KEY];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setDefaultsIfNecessary];

    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_URL_KEY];

    [self initStatusMenu];

    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

#ifndef DEBUG
    [self toggleBackground:self];
#endif
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    const SEL action = [menuItem action];

    if (action == @selector(toggleBackground:)
        || action == @selector(loadUrl:)
        || action == @selector(openLoadUrlWindow:)
        || action == @selector(zoomIn:)
        || action == @selector(zoomToActualSize:)
        || action == @selector(zoomOut:))
    {
        return YES;
    }

    return NO;
}

- (IBAction)openLoadUrlWindow:(id)sender {
    NSApplication *const application = [NSApplication sharedApplication];
    [application activateIgnoringOtherApps:YES];

    [self.urlField setStringValue:[self.webView mainFrameURL]];
    [self.urlWindow makeKeyAndOrderFront:self];
    [self.urlWindow orderFront:self];

    [application deactivate];
}

- (IBAction)loadUrl:(id)sender {
    [self.urlWindow orderOut:self];

    NSString *const string = [self.urlField stringValue];
    NSURL *url = [NSURL URLWithString:string];
    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];

    [[NSUserDefaults standardUserDefaults] setObject:string forKey:DEFAULT_URL_KEY];
}

- (IBAction)toggleBackground:(id)sender {
    [self.window toggleDesktopBackground];
    [_webView.mainFrame.frameView setAllowsScrolling:!self.window.background];
}

- (IBAction)zoomIn:(id)sender {
    [_webView zoomPageIn:self];
}

- (IBAction)zoomToActualSize:(id)sender {
    [_webView resetPageZoom:self];
}

- (IBAction)zoomOut:(id)sender {
    [_webView zoomPageOut:self];
}

@end
