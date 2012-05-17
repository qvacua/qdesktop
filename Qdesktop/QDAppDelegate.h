#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class QDWindow;

@interface QDAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSMenu *statusMenu;

@property (assign) IBOutlet QDWindow *window;
@property (assign) IBOutlet WebView *webView;

@property (assign) IBOutlet NSWindow *urlWindow;
@property (assign) IBOutlet NSTextField *urlField;

- (IBAction)toggleBackground:(id)sender;

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomToActualSize:(id)sender;
- (IBAction)zoomOut:(id)sender;

- (IBAction)openLoadUrlWindow:(id)sender;
- (IBAction)loadUrl:(id)sender;

@end
