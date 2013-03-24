/**
 * Tae Won Ha
 * http://qvacua.com
 * https://github.com/qvacua
 *
 * See LICENSE
 */

#import "QDWindow.h"

@interface QDWindow ()

@property (readwrite) BOOL background;

@end

@implementation QDWindow {
}

@synthesize background = _background;

- (NSSize)screenResolution {
    NSSize size = [[NSScreen mainScreen] visibleFrame].size;
    size.height += 4;   // to compensate the shadow of the menu bar

    return size;
}

- (void)toggleDesktopBackground {
    if (self.background) {
        [self setLevel:NSNormalWindowLevel];
        [self makeKeyAndOrderFront:self];

        self.background = NO;
        return;
    }

    [self setLevel:kCGDesktopWindowLevel];
    [self orderBack:self];

    self.background = YES;
}

- (void)fillScreen {
    [self setContentSize:[self screenResolution]];
    [self setFrameOrigin:NSMakePoint(0, 0)];
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {
#ifdef DEBUG
    self = [super initWithContentRect:contentRect styleMask:windowStyle backing:bufferingType defer:deferCreation];
#else
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:deferCreation];
#endif

    if(self) {
        _background = NO;

#ifndef DEBUG
        [self setCollectionBehavior:(NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorTransient | NSWindowCollectionBehaviorIgnoresCycle)];
        [self fillScreen];
#endif

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenChange) name:NSApplicationDidChangeScreenParametersNotification object:nil];
    }

    return self;
}

- (BOOL)acceptsFirstResponder {
    return !self.background;
}

- (BOOL)canBecomeMainWindow {
    return !self.background;
}

- (BOOL)canBecomeKeyWindow {
    return !self.background;
}

- (void)handleScreenChange {
    [self setContentSize:[self screenResolution]];
    [self setFrameOrigin:NSMakePoint(0, 0)];
}

@end
