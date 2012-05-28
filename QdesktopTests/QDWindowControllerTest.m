#import "QDBaseTest.h"
#import <WebKit/WebKit.h>
#import "QDWindowController.h"
#import "WebView+QDZoom.h"

@interface QDWindowControllerTest : QDBaseTest  @end

@implementation QDWindowControllerTest {
    QDWindowController *controller;
    NSWindow *window;
    WebView *webView;
    WebFrame *mainFrame;
}

- (void)setUp {
    controller = [[QDWindowController alloc] init];

    window = mock([NSWindow class]);
    webView = mock([WebView class]);
    mainFrame = mock([WebFrame class]);

    controller.window = window;
    controller.webView = webView;

    [given([webView mainFrame]) willReturn:mainFrame];
}

- (void)testSetUrlObserving {
    NSURL *const url = [[NSURL alloc] initWithString:@"http://new.url"];
    controller.url = url;

    ArgumentCaptor *captor = argCaptor();
    [verify(mainFrame) loadRequest:captor];

    NSURLRequest *urlReq = captor.argument;
    assertThat(urlReq.URL, is(url));
}

- (void)testZoomIbActions {
    [controller zoomIn:self];
    [verify(webView) zoomPageIn:anything()];

    [controller zoomOut:self];
    [verify(webView) zoomPageOut:anything()];

    [controller zoomToActualSize:self];
    [verify(webView) resetPageZoom:anything()];
}

@end
