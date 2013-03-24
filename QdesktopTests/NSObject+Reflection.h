/**
 * Tae Won Ha
 * http://qvacua.com
 * https://github.com/qvacua
 *
 * See LICENSE
 */

#import <Foundation/Foundation.h>

@interface NSObject (Reflection)

- (void)setInstanceVarTo:(id)object;
- (void)setInstanceVarTo:(id)object implementingProtocol:(Protocol *)protocol;

- (id)instanceVarOfClass:(Class)clazz;


@end
