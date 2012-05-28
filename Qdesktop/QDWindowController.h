#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface QDWindowController : NSObject <NSWindowDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet WebView *webView;

@property (strong, readwrite) NSURL *url;

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomToActualSize:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end
