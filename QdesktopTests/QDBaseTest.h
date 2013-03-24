/**
 * Tae Won Ha
 * http://qvacua.com
 * https://github.com/qvacua
 *
 * See LICENSE
 */

#import <SenTestingKit/SenTestingKit.h>
#import "NSObject+Reflection.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "ArgumentCaptor.h"

#define hasSize(number) hasCount(equalToInt(number))
#define consistsOf(...) contains(__VA_ARGS__, nil)
#define consistsOfInAnyOrder(...) containsInAnyOrder(__VA_ARGS__, nil)

@interface QDBaseTest : SenTestCase
@end
