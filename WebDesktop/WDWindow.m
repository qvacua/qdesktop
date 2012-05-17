#import "WDWindow.h"

@interface WDWindow ()
- (NSSize)screenResolution;
@end

@implementation WDWindow {
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

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:deferCreation];

    if(self) {
        _background = NO;

        [self setCollectionBehavior:(NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorTransient | NSWindowCollectionBehaviorIgnoresCycle)];

        NSSize mainScreenSize = [self screenResolution];
        [self setFrameOrigin:NSMakePoint(0, 0)];
        [self setContentSize:mainScreenSize];

        [self toggleDesktopBackground];
    }

    return self;
}

- (BOOL)canBecomeMainWindow {
    return !self.background;
}

- (BOOL)canBecomeKeyWindow {
    return !self.background;
}

@end