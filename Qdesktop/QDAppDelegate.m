#import "QDAppDelegate.h"
#import "QDWindow.h"
#import "WebView+QDZoom.h"

static NSString *const qDefaultUrlKey = @"url";
static NSString *const qDefaultUrlValue = @"http://www.qvacua.com";

@interface QDAppDelegate ()

@property NSStatusItem *statusItem;

@end

@implementation QDAppDelegate {
}

@synthesize window = _window;
@synthesize webView = _webView;
@synthesize statusMenu = _statusMenu;
@synthesize urlWindow = _urlWindow;
@synthesize urlField = _urlField;
@synthesize statusItem = _statusItem;

- (void)initStatusMenu {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

    [self.statusItem setTitle:@"😎"];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.statusMenu];
}

- (void)setDefaultsIfNecessary {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if ([userDefaults objectForKey:qDefaultUrlKey] == nil) {
        [userDefaults setObject:qDefaultUrlValue forKey:qDefaultUrlKey];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setDefaultsIfNecessary];

    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:qDefaultUrlKey];

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

    [[NSUserDefaults standardUserDefaults] setObject:string forKey:qDefaultUrlKey];
}

- (IBAction)toggleRegularReload:(id)sender {
}

- (IBAction)toggleBackground:(id)sender {
    [self.window toggleDesktopBackground];
    [self.webView.mainFrame.frameView setAllowsScrolling:!self.window.background];
}

- (IBAction)zoomIn:(id)sender {
    [self.webView zoomPageIn:self];
}

- (IBAction)zoomToActualSize:(id)sender {
    [self.webView resetPageZoom:self];
}

- (IBAction)zoomOut:(id)sender {
    [self.webView zoomPageOut:self];
}

@end
