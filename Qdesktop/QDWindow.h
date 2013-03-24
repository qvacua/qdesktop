/**
 * Tae Won Ha
 * http://qvacua.com
 * https://github.com/qvacua
 *
 * See LICENSE
 */

#import <Cocoa/Cocoa.h>

@interface QDWindow : NSWindow

@property (readonly, getter=isBackground) BOOL background;

- (void)toggleDesktopBackground;

@end
