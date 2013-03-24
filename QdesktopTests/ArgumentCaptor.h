/**
 * Tae Won Ha
 * http://qvacua.com
 * https://github.com/qvacua
 *
 * See LICENSE
 */

#import <OCHamcrest/HCBaseMatcher.h>
#import <objc/objc-api.h>

@interface ArgumentCaptor : HCBaseMatcher

@property (strong, readonly) id argument;

- (id <HCMatcher>)matcher;

@end

OBJC_EXPORT ArgumentCaptor *argCaptor();
