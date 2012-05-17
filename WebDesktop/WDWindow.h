//
// Created by hat on 5/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface WDWindow : NSWindow

@property (assign, readonly, getter=isBackground) BOOL background;

- (void)toggleDesktopBackground;


@end