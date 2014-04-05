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
static NSString *const qDefaultUrlValue = @"http://qvacua.com";
static NSString *const qDefaultReloadRegularlyKey = @"update-regularly";
static NSString *const qDefaultIntervalKey = @"interval";
static const int qDefaultIntervalValue = 15;

@interface QDAppDelegate ()

@property NSUserDefaults *userDefaults;
@property NSStatusItem *statusItem;
@property NSURL *url;
@property BOOL reloadRegularly;
@property NSInteger interval;
@property NSTimer *timer;

@end

@implementation QDAppDelegate

#pragma mark NSUserInterfaceValidations
- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem {
    const SEL action = anItem.action;

    if (action == @selector(toggleBackground:)
            || action == @selector(prefsWindowOk:)
            || action == @selector(openPrefsWindow:)
            || action == @selector(zoomIn:)
            || action == @selector(zoomToActualSize:)
            || action == @selector(zoomOut:)) {
        return YES;
    }

    return NO;
}

#pragma mark IBActions
- (IBAction)openPrefsWindow:(id)sender {
    NSApplication *const application = [NSApplication sharedApplication];
    [application activateIgnoringOtherApps:YES];

    [self syncPrefsUiElements];

    [self.urlWindow makeKeyAndOrderFront:self];
    [self.urlWindow orderFront:self];

    [application deactivate];
}

- (IBAction)prefsWindowOk:(id)sender {
    [self.urlWindow orderOut:self];

    [self storeNewDefaults];

    [self updateWebView];
    [self resetTimer];
}

- (IBAction)toggleRegularReload:(id)sender {
    // noop: the timer is reset in -prefsWindowOk:
}

- (IBAction)toggleBackground:(id)sender {
    [self.window toggleDesktopBackground];
    self.webView.mainFrame.frameView.allowsScrolling = !self.window.background;
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

    [self setDefaultFontSize];
    [self updateWebView];

    [self resetTimer];

#ifndef DEBUG
    [self toggleBackground:self];
#endif
}

#pragma mark Private
- (void)setDefaultFontSize {
    self.webView.preferences.defaultFontSize = 16;
    self.webView.preferences.defaultFixedFontSize = 16;
    self.webView.preferences.minimumFontSize = 9;
}

- (void)updateWebView {
    [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:self.url]];

    NSLog(@"updated webview with %@", self.url);
}

- (void)initStatusMenu {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

    self.statusItem.title = @"😎";
    self.statusItem.highlightMode = YES;
    self.statusItem.menu = self.statusMenu;
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
}

- (void)storeNewDefaults {
    self.url = [NSURL URLWithString:[self.urlField stringValue]];
    [self.userDefaults setObject:self.url.absoluteString forKey:qDefaultUrlKey];

    self.reloadRegularly = NO;
    if (self.regularReloadCheckbox.state == NSOnState) {
        self.reloadRegularly = YES;
    }
    [self.userDefaults setBool:self.reloadRegularly forKey:qDefaultReloadRegularlyKey];

    self.interval = self.intervalTextField.integerValue;
    [self.userDefaults setInteger:self.interval forKey:qDefaultIntervalKey];
}

- (void)syncPrefsUiElements {
    self.urlField.stringValue = self.url.absoluteString;

    self.regularReloadCheckbox.state = NSOffState;
    if (self.reloadRegularly) {
        self.regularReloadCheckbox.state = NSOnState;
    }

    self.intervalTextField.integerValue = self.interval;
}

- (void)resetTimer {
    [self.timer invalidate];
    self.timer = nil;

    if (!self.reloadRegularly) {
        return;
    }

    self.timer = [NSTimer timerWithTimeInterval:(self.interval * 60) target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];

    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)timerFireMethod:(NSTimer *)theTimer {
    [self updateWebView];
}

@end
