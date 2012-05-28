#import "ArgumentCaptor.h"

@implementation ArgumentCaptor {
@private
    id _argument;
}

@synthesize argument = _argument;

+ (id)argumentCaptor {
    return [[ArgumentCaptor alloc] init];
}

- (BOOL)matches:(id)item {
    _argument = item;
    return YES;
}

ArgumentCaptor *argCaptor() {
    return [ArgumentCaptor argumentCaptor];
}

@end
