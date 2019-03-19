//
//  ObservableMutableArrayWrapper.m
//
//  Created by wujungao on 2019/3/6.
//  Copyright © 2019 wjg. All rights reserved.
//

#import "ObservableMutableArrayWrapper.h"

NSString * const CCObservableArrayKey=@"array";
NSString * const CCObservableCountKey=@"arrayCount";

@interface ObservableMutableArrayWrapper ()

@property (nonatomic, strong, nullable) NSMutableArray *array;

@end

@implementation ObservableMutableArrayWrapper

#pragma mark - life circle

#pragma mark - pub

#pragma mark - get obj
- (nullable id)objectInArrayAtIndex:(NSUInteger)index {
    if (![self isValidIndexForOtherOperation:index]) return nil;

    return [self.array objectAtIndex:index];
}

- (nullable NSArray *)arrayAtIndexes:(NSIndexSet *)indexes {
    if (![ObservableMutableArrayWrapper isValidindexes:indexes]) return nil;

    return [self.array objectsAtIndexes:indexes];
}

- (nonnull NSArray *)allObjects {
    return [self.array copy];
}

#pragma mark - add
- (void)insertObject:(_Nonnull id)object inArrayAtIndex:(NSUInteger)index {
    if (![ObservableMutableArrayWrapper isValidObject:object]) return;
    if (![self isValidIndexForInsert:index]) return;

    [self willChangeValueForKey:TBObservableCountKey];

    [self.array insertObject:object atIndex:index];

    [self didChangeValueForKey:TBObservableCountKey];
}

- (void)insertArray:(nonnull NSArray *)array atIndexes:(nonnull NSIndexSet *)indexes {
    if (![ObservableMutableArrayWrapper isValidArray:array]) return;
    if (![ObservableMutableArrayWrapper isValidindexes:indexes]) return;

    [self willChangeValueForKey:TBObservableCountKey];

    [self.array insertObjects:array atIndexes:indexes];

    [self didChangeValueForKey:TBObservableCountKey];
}

- (void)appendingArray:(nonnull NSArray *)array {
    if (![ObservableMutableArrayWrapper isValidArray:array]) return;

    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self arrayCount], [array count])];
    [self insertArray:array atIndexes:indexSet];
}

#pragma mark - remove
- (void)removeArrayAtIndexes:(nonnull NSIndexSet *)indexes {
    if (![ObservableMutableArrayWrapper isValidindexes:indexes]) return;

    [self willChangeValueForKey:TBObservableCountKey];

    [self.array removeObjectsAtIndexes:indexes];

    [self didChangeValueForKey:TBObservableCountKey];
}

- (void)removeObjectFromArrayAtIndex:(NSUInteger)index {
    if (![self isValidIndexForOtherOperation:index]) return;

    [self willChangeValueForKey:TBObservableCountKey];

    [self.array removeObjectAtIndex:index];

    [self didChangeValueForKey:TBObservableCountKey];
}

//-(void)removeArrayObject:(_Nonnull id)object{
//    
//    [self willChangeValueForKey:TBObservableCountKey];
//    
//    [self.array removeObject:object];
//    
//    [self didChangeValueForKey:TBObservableCountKey];
//}

- (void)removeAllObjects {
    [self willChangeValueForKey:TBObservableCountKey];

    [self.array removeAllObjects];

    [self didChangeValueForKey:TBObservableCountKey];
}

#pragma mark - replace
- (void)replaceObjectInArrayAtIndex:(NSUInteger)index withObject:(_Nonnull id)object {
    if (![ObservableMutableArrayWrapper isValidObject:object]) return;
    if (![self isValidIndexForOtherOperation:index]) return;

    [self.array replaceObjectAtIndex:index withObject:object];
}

- (void)replaceArrayAtIndexes:(nonnull NSIndexSet *)indexes withArray:(nonnull NSArray *)array {
    if (![ObservableMutableArrayWrapper isValidArray:array]) return;
    if (![ObservableMutableArrayWrapper isValidindexes:indexes]) return;

    [self.array replaceObjectsAtIndexes:indexes withObjects:array];
}

#pragma mark - count
- (NSUInteger)arrayCount {
    return self.array.count;
}

#pragma mark - private
+ (BOOL)isValidArray:(nullable NSArray *)array {
    if (array == nil || array == NULL || ![array isKindOfClass:[NSArray class]]) return NO;
    if (array.count == 0) return NO;
    
    return YES;
}

+ (BOOL)isValidObject:(nullable id)object {
    if (object == nil || object == NULL) return NO;

    return YES;
}

- (BOOL)isValidIndexForInsert:(NSUInteger)index {
    if (index > self.array.count || index < 0) return NO;

    return YES;
}

- (BOOL)isValidIndexForOtherOperation:(NSUInteger)index {
    if (index >= self.array.count || index < 0) return NO;

    return YES;
}

+ (BOOL)isValidindexes:(nullable NSIndexSet *)indexes {
    if (indexes == nil || indexes == NULL || ![indexes isKindOfClass:[NSIndexSet class]]) return NO;
    if (indexes.count == 0) return NO;
    
    return YES;
}

#pragma mark - property
- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray arrayWithCapacity:1];
    }

    return _array;
}

@end
