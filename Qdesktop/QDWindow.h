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

#pragma mark Public
- (void)toggleDesktopBackground;

#pragma mark NSWindow
- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation;
- (BOOL)canBecomeMainWindow;
- (BOOL)canBecomeKeyWindow;

#pragma mark NSResponder
- (BOOL)acceptsFirstResponder;

@end
