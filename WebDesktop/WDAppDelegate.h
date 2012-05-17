#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class WDWindow;
@class WDWebView;

@interface WDAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet WDWindow *window;
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSMenu *statusMenu;

@property (assign) IBOutlet NSWindow *urlWindow;

- (IBAction)toggleBackground:(id)sender;

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomToActualSize:(id)sender;
- (IBAction)zoomOut:(id)sender;

- (IBAction)loadUrl:(id)sender;

@end
