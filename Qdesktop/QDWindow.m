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

@implementation QDWindow

#pragma mark Public
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

#pragma mark NSWindow
- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {

#ifdef DEBUG
    self = [super initWithContentRect:contentRect styleMask:windowStyle backing:bufferingType defer:deferCreation];
#else
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType
                                defer:deferCreation];
#endif

    if (!self) {
        return nil;
    }

    _background = NO;

#ifndef DEBUG
    self.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces
            | NSWindowCollectionBehaviorTransient
            | NSWindowCollectionBehaviorIgnoresCycle;
    [self fillScreen];
#endif

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleScreenChange)
                                                 name:NSApplicationDidChangeScreenParametersNotification
                                               object:nil];

    return self;
}

- (BOOL)canBecomeMainWindow {
    return !self.background;
}

- (BOOL)canBecomeKeyWindow {
    return !self.background;
}

#pragma mark NSResponder
- (BOOL)acceptsFirstResponder {
    return !self.background;
}

#pragma mark Private
- (NSSize)screenResolution {
    NSSize mainScreenSize = [[NSScreen mainScreen] frame].size;
    CGFloat menuBarThickness = [[NSStatusBar systemStatusBar] thickness];

    mainScreenSize.height -= menuBarThickness;

    return mainScreenSize;
}

- (void)fillScreen {
    self.contentSize = self.screenResolution;
    self.frameOrigin = CGPointZero;
}

- (void)handleScreenChange {
    self.contentSize = self.screenResolution;
    self.frameOrigin = CGPointZero;
}

@end
