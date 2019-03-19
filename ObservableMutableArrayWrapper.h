//
//  ObservableMutableArrayWrapper.h
//
//  Created by wujungao on 2019/3/6.
//  Copyright © 2019 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

//这个key，observer可以随时监听到数组内容的动态变化，以及在监听中获取动态变化的内容
//动态变化包括：插入、删除、替换
extern NSString * const CCObservableArrayKey;

//这个key，observer可以随时监听到数组元素数量变化，以及在监听中获取到变化后的数量
//变化范围：插入、删除
extern NSString * const CCObservableCountKey;

NS_ASSUME_NONNULL_BEGIN

@interface ObservableMutableArrayWrapper<CCObjectType> : NSObject

#pragma mark - get obj

/**
 @brief 获取数组指定位置的元素

 @param index 元素在数组的位置
 @return 返回的元素（一个对象，任意CCObjectType--即id类型对象）
 */
- (nullable CCObjectType)objectInArrayAtIndex:(NSUInteger)index;

/**
 @brief 获取数组指定的多个位置的元素

 @param indexes 元素在数组的多个位置
 @return 返回一个新的数组（这个数组包含indexes指定的位置上的元素）
 */
- (nullable NSArray<CCObjectType> *)arrayAtIndexes:(NSIndexSet *)indexes;

/**
 @brief 获取数组所有元素

 @return 返回数组所有元素（以一个新数组形式返回）

 @discussion 如果数组元素支持NSCopying协议，比如里面所有元素都是String，那么返回的新数组所有元素与原数组所有元素是内容相同的不同对象；
 否则，返回的新数组是相同的对象的引用（强引用），如果在新数组中对元素操作，会影响原数组元素内容
 */
- (nonnull NSArray<CCObjectType> *)allObjects;

#pragma mark - add

/**
 @brief 向数组指定位置插入元素

 @param object 插入数组的元素
 @param index 插入数组的位置
 */
- (void)insertObject:(_Nonnull CCObjectType)object inArrayAtIndex:(NSUInteger)index;

/**
 @brief 向数组多个位置，插入多个元素

 @param array 插入数组的多个元素（以数组形式传入）
 @param indexes 插入数组的多个位置
 */
- (void)insertArray:(nonnull NSArray<CCObjectType> *)array atIndexes:(nonnull NSIndexSet *)indexes;

/**
 @brief 附加多个元素到数组末尾（append）

 @param array 附加到数组的多个元素（以数组形式传入）
 */
- (void)appendingArray:(nonnull NSArray<CCObjectType> *)array;

#pragma mark - remove

/**
 @brief 删除数组指定的多个位置上的元素

 @param indexes 数组上的多个位置
 */
- (void)removeArrayAtIndexes:(NSIndexSet *)indexes;

/**
 @brief 删除数组指定的某个位置上的元素

 @param index 数组上指定的某个位置
 */
- (void)removeObjectFromArrayAtIndex:(NSUInteger)index;

/**
 @brief 删除数组所有元素（清空数组）
 */
- (void)removeAllObjects;

#pragma mark - replace

/**
 @brief 用某个元素（object），替换数组上指定位置上的元素。

 @param index 数组上的指定位置
 @param object 用来替换数组指定位置元素的元素（即传入的参数：object）
 */
- (void)replaceObjectInArrayAtIndex:(NSUInteger)index withObject:(_Nonnull CCObjectType)object;

/**
 @brief 用传入的参数array中的元素，批量替换数组指定的多个位置上的元素

 @param indexes 数组上指定的多个位置
 @param array 用来替换指定的多个位置上的多个元素的元素数组
 */
- (void)replaceArrayAtIndexes:(nonnull NSIndexSet *)indexes withArray:(nonnull NSArray<CCObjectType> *)array;

#pragma mark - count

/**
 @brief 数组元素的数量

 @return 返回数组元素的数量
 */
- (NSUInteger)arrayCount;

@end

NS_ASSUME_NONNULL_END
