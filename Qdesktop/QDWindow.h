#import <Cocoa/Cocoa.h>

@interface QDWindow : NSWindow

@property (readonly, getter=isBackground) BOOL background;

- (void)toggleDesktopBackground;

@end
