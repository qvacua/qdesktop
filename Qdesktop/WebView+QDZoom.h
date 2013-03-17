#import <WebKit/WebKit.h>

/**
* Declaring the following three IBActions to access them as they seem to be private.
*/
@interface WebView (QDZoom)

- (IBAction)zoomPageIn:(id)sender;
- (IBAction)zoomPageOut:(id)sender;
- (IBAction)resetPageZoom:(id)sender;

@end
