#import "WDAppDelegate.h"
#import "WDWindow.h"
#import "WebView+WDZoom.h"

@interface WDAppDelegate ()
- (void)activateStatusMenu;
@end

@implementation WDAppDelegate {
    NSStatusItem *_statusItem;
}

@synthesize window = _window;
@synthesize webView = _webView;
@synthesize statusMenu = _statusMenu;
@synthesize urlWindow = _urlWindow;

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
    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.huffingtonpost.com/"]]];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    const SEL action = [menuItem action];

    if (action == @selector(toggleBackground:)) {
        return YES;
    }

    if (action == @selector(zoomIn:)
        || action == @selector(zoomToActualSize:)
        || action == @selector(zoomOut:)) {
        return YES;
    }

    return [super validateMenuItem:menuItem];
}

- (IBAction)loadUrl:(id)sender {

}

- (IBAction)toggleBackground:(id)sender {
    [self.window toggleDesktopBackground];
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
