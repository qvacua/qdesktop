/**
 * Tae Won Ha
 * http://qvacua.com
 * https://github.com/qvacua
 *
 * See LICENSE
 */

#import "QDAppDelegate.h"
#import "QDWindow.h"
#import "WebView+QDZoom.h"

static NSString *const qDefaultUrlKey = @"url";
static NSString *const qDefaultUrlValue = @"http://www.hataewon.com";
static NSString *const qDefaultReloadRegularlyKey = @"update-regularly";
static NSString *const qDefaultIntervalKey = @"interval";
static const int qDefaultIntervalValue = 15;

@interface QDAppDelegate ()

@property NSUserDefaults *userDefaults;
@property NSStatusItem *statusItem;
@property NSURL *url;
@property BOOL reloadRegularly;
@property NSInteger interval;

@end

@implementation QDAppDelegate {
}

@synthesize window = _window;
@synthesize webView = _webView;
@synthesize statusMenu = _statusMenu;
@synthesize urlWindow = _urlWindow;
@synthesize urlField = _urlField;
@synthesize statusItem = _statusItem;
@synthesize userDefaults = _userDefaults;
@synthesize url = _url;
@synthesize reloadRegularly = _reloadRegularly;
@synthesize interval = _interval;

#pragma mark NSUserInterfaceValidations
- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem {
    const SEL action = [anItem action];

    if (action == @selector(toggleBackground:)
            || action == @selector(loadUrl:)
            || action == @selector(openPrefsWindow:)
            || action == @selector(zoomIn:)
            || action == @selector(zoomToActualSize:)
            || action == @selector(zoomOut:))
    {
        return YES;
    }

    return NO;
}

#pragma mark IBActions
- (IBAction)openPrefsWindow:(id)sender {
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

#pragma mark NSAppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.userDefaults = [NSUserDefaults standardUserDefaults];

    [self setDefaultsIfNecessary];
    [self readDefaults];

    [self initStatusMenu];

    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:self.url]];

#ifndef DEBUG
    [self toggleBackground:self];
#endif
}

#pragma mark Private
- (void)initStatusMenu {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

    [self.statusItem setTitle:@"😎"];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.statusMenu];
}

- (void)setDefaultsIfNecessary {
    if ([self.userDefaults objectForKey:qDefaultUrlKey] == nil) {
        [self.userDefaults setObject:qDefaultUrlValue forKey:qDefaultUrlKey];
    }

    if ([self.userDefaults objectForKey:qDefaultIntervalKey] == nil) {
        [self.userDefaults setInteger:qDefaultIntervalValue forKey:qDefaultIntervalKey];
    }
}

- (void)readDefaults {
    self.url = [NSURL URLWithString:[self.userDefaults objectForKey:qDefaultUrlKey]];
    self.reloadRegularly = [self.userDefaults boolForKey:qDefaultReloadRegularlyKey];
    self.interval = [self.userDefaults integerForKey:qDefaultIntervalKey];

    [self.regularReloadCheckbox setState:NSOffState];
    [self.intervalTextField setIntegerValue:self.interval];

    if (self.reloadRegularly) {
        [self.regularReloadCheckbox setState:NSOnState];
    }
}

@end
