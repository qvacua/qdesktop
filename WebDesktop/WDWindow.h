#import <Cocoa/Cocoa.h>

@interface WDWindow : NSWindow

@property (assign, readonly, getter=isBackground) BOOL background;

- (void)toggleDesktopBackground;

- (void)setFrameToMainScreen;


@end