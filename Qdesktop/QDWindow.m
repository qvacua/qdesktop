#import "QDWindow.h"

@interface QDWindow ()
- (NSSize)screenResolution;

- (void)fillScreen;

@end

@implementation QDWindow {
    BOOL _background;
}

@synthesize background = _background;

- (NSSize)screenResolution {
    return [[NSScreen mainScreen] frame].size;
}

- (void)toggleDesktopBackground {
    if (self.background) {
        [self setLevel:NSNormalWindowLevel];
        [self makeKeyAndOrderFront:self];

        _background = NO;
        return;
    }

    [self setLevel:kCGDesktopWindowLevel];
    [self orderBack:self];

    _background = YES;
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

@end