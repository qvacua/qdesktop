/**
 * Tae Won Ha
 * http://qvacua.com
 * https://github.com/qvacua
 *
 * See LICENSE
 */

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@class QDWindow;

@interface QDAppDelegate : NSObject <NSApplicationDelegate, NSUserInterfaceValidations>

@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet QDWindow *window;
@property (weak) IBOutlet WebView *webView;
@property (weak) IBOutlet NSWindow *urlWindow;
@property (weak) IBOutlet NSTextField *urlField;
@property (weak) IBOutlet NSTextField *intervalTextField;
@property (weak) IBOutlet NSButton *regularReloadCheckbox;

#pragma mark IBActions
- (IBAction)toggleBackground:(id)sender;
- (IBAction)toggleRegularReload:(id)sender;

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomToActualSize:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)openPrefsWindow:(id)sender;
- (IBAction)prefsWindowOk:(id)sender;

#pragma mark NSUserInterfaceValidations
- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem;

#pragma mark NSAppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

@end
