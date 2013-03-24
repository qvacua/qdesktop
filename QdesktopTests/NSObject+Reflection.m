/**
 * Tae Won Ha
 * http://qvacua.com
 * https://github.com/qvacua
 *
 * See LICENSE
 */

#import <objc/runtime.h>
#import <OCMockito/OCMockito.h>
#import "NSObject+Reflection.h"

static BOOL iterateViaClass(Ivar *ivars, unsigned int ivarCount, Class objectClass, void (^processor)(Ivar)) {

    unsigned int foundRelevantIvar = 0;
    Ivar resultIvar = NULL;

    for (unsigned int i = 0; i < ivarCount; i++) {
        NSString *ivarType = [[NSString alloc] initWithCString:ivar_getTypeEncoding(ivars[i]) encoding:NSASCIIStringEncoding];

        if ([ivarType characterAtIndex:0] != '@') {
            continue;
        }

        if ([ivarType length] <= 3) {
            continue;
        }

        NSString *ivarClass = [ivarType substringWithRange:NSMakeRange(2, [ivarType length] - 3)];
        if ([ivarClass isEqualToString:NSStringFromClass(objectClass)]) {
            resultIvar = ivars[i];
            foundRelevantIvar++;
        }
    }

    if (foundRelevantIvar == 1) {
        processor(resultIvar);
        free(ivars);
        return YES;
    }

    free(ivars);

    if (foundRelevantIvar > 1) {
        @throw [NSException exceptionWithName:@"MultipleInstanceVariables"
                                       reason:[NSString stringWithFormat:@"more than one instance variables of type %@", objectClass]
                                     userInfo:nil];
    }

    if (foundRelevantIvar == 0) {
        return NO;
    }

    return NO;
}

static BOOL iterateViaProtocol(Ivar *ivars, unsigned int ivarCount, Protocol *objectProtocol, void (^processor)(Ivar)) {

    unsigned int foundRelevantIvar = 0;
    Ivar resultIvar = NULL;

    for (unsigned int i = 0; i < ivarCount; i++) {
        NSString *ivarType = [[NSString alloc] initWithCString:ivar_getTypeEncoding(ivars[i]) encoding:NSASCIIStringEncoding];

        if ([ivarType characterAtIndex:0] != '@') {
            continue;
        }

        if ([ivarType length] <= 5) {
            continue;
        }

        NSString *ivarClass = [ivarType substringWithRange:NSMakeRange(3, [ivarType length] - 5)];
        if ([ivarClass isEqualToString:NSStringFromProtocol(objectProtocol)]) {
            resultIvar = ivars[i];
            foundRelevantIvar++;
        }
    }

    if (foundRelevantIvar == 1) {
        processor(resultIvar);
        free(ivars);
        return YES;
    }

    free(ivars);

    if (foundRelevantIvar > 1) {
        @throw [NSException exceptionWithName:@"MultipleInstanceVariables"
                                       reason:[NSString stringWithFormat:@"more than one instance variables implementing %@", NSStringFromProtocol(objectProtocol)]
                                     userInfo:nil];
    }

    if (foundRelevantIvar == 0) {
        return NO;
    }

    return NO;
}

/**
* Sets the instance variable of target with object. It does take the super classes into account.
*/
static void wireWithViaClass(id target, id object) {
    Class objectClass = [object class];

    if (objectClass == [MKTObjectMock class]) {
        objectClass = [object mockedClass];
    }

    Class superClass = [target class];
    while (superClass != [NSObject class]) {

        Ivar *ivars;
        unsigned int ivarCount = 0;

        ivars = class_copyIvarList(superClass, &ivarCount);

        BOOL successfullySet = iterateViaClass(ivars, ivarCount, objectClass, ^(Ivar ivar) {
            object_setIvar(target, ivar, object);
        });

        if (successfullySet) {
            return;
        } else {
            superClass = [superClass superclass];
        }
    }

    if (superClass == [NSObject class]) {
        @throw [NSException exceptionWithName:@"NoInstanceVariable"
                                       reason:[NSString stringWithFormat:@"no instance variables of type %@", objectClass]
                                     userInfo:nil];
    }
}

static void wireWithViaProtocol(id target, id object, Protocol *protocol) {
    Class superClass = [target class];
    while (superClass != [NSObject class]) {

        Ivar *ivars;
        unsigned int ivarCount = 0;

        ivars = class_copyIvarList(superClass, &ivarCount);

        BOOL successfullySet = iterateViaProtocol(ivars, ivarCount, protocol, ^(Ivar ivar) {
            object_setIvar(target, ivar, object);
        });

        if (successfullySet) {
            return;
        } else {
            superClass = [superClass superclass];
        }
    }

    if (superClass == [NSObject class]) {
        @throw [NSException exceptionWithName:@"NoInstanceVariable"
                                       reason:[NSString stringWithFormat:@"no instance variables implementing protocol  %@", NSStringFromProtocol(protocol)]
                                     userInfo:nil];
    }
}

/**
* Returns the instance variable of target with object. It does take the super classes into account.
*/
static id valueOfViaClass(id target, Class objectClass) {
    Class superClass = [target class];

    __block id object = nil;
    while (superClass != [NSObject class]) {

        Ivar *ivars;
        unsigned int ivarCount = 0;

        ivars = class_copyIvarList(superClass, &ivarCount);

        BOOL successfullySet = iterateViaClass(ivars, ivarCount, objectClass, ^(Ivar ivar) {
            object = object_getIvar(target, ivar);
        });

        if (successfullySet) {
            return object;
        } else {
            superClass = [superClass superclass];
        }
    }

    if (superClass == [NSObject class]) {
        @throw [NSException exceptionWithName:@"NoInstanceVariable"
                                       reason:[NSString stringWithFormat:@"no instance variables of type %@", objectClass]
                                     userInfo:nil];
    }

    return object;
}

@implementation NSObject (Reflection)

- (void)setInstanceVarTo:(id)object {
    wireWithViaClass(self, object);
}

- (void)setInstanceVarTo:(id)object implementingProtocol:(Protocol *)protocol {
    wireWithViaProtocol(self, object, protocol);
}

- (id)instanceVarOfClass:(Class)clazz {
    return valueOfViaClass(self, clazz);
}

@end
