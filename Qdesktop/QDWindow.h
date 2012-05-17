#import <Cocoa/Cocoa.h>

@interface QDWindow : NSWindow

@property (assign, readonly, getter=isBackground) BOOL background;

- (void)toggleDesktopBackground;

- (void)setFrameToMainScreen;


@end