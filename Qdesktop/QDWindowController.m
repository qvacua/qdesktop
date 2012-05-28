#import "QDWindowController.h"
#import "WebView+QDZoom.h"

@implementation QDWindowController {
@private
    NSURL *_url;
}

@synthesize window = _window;
@synthesize webView = _webView;
@synthesize url = _url;

- (id)init {
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"url" options:NSKeyValueObservingOptionNew context:NULL];
    }

    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"url"]) {
        NSURL *oldUrl = [change objectForKey:NSKeyValueChangeOldKey];
        NSURL *newUrl = [change objectForKey:NSKeyValueChangeNewKey];

        if ([newUrl isEqualTo:oldUrl]) {
            return;
        }

        [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
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
