#define THROW_ABSTRACT_METHOD_EXCEPTION() \
[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass/category", NSStringFromSelector(_cmd)];

#define THROW_ABSTRACT_METHOD_EXCEPTION_AND_RETURN(value) \
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass/category", NSStringFromSelector(_cmd)]; \
    return value;