//
//  RuntimeDump.m
//
//  Created by wjg on 2018/10/8.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "RuntimeDump.h"
#import <objc/runtime.h>

@implementation RuntimeDump

+ (void)ivarWithObject:(id)object{
    NSLog(@"%@",object);
    NSLog(@"==================================================");
    const char *className = object_getClassName(object);
    id class = objc_getClass(className);
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    NSLog(@"---%d",outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        fprintf(stdout, "%s %s\n", property_getName(property), property_getAttributes(property));
    }
    NSLog(@"--------------------------------------------------");
    unsigned int numIvars = 0;
    Ivar * ivars = class_copyIvarList(class, &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *name = ivar_getName(thisIvar);
        NSString *nameString =  [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        NSLog(@"%@,%@",stringType,nameString);
    }
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++");
}

// 获取实例方法
+(void)getMethodsWithObject:(id)object{
    int outCount = 0;
    Method *methods = class_copyMethodList([object class], &outCount);
    
    for (int i = 0; i < outCount; i ++) {
        NSLog(@"=============%d", i);
        // 获取方法名
        Method method = methods[i];
        SEL methodName = method_getName(method);
        NSLog(@"方法名= %@", NSStringFromSelector(methodName));
        // 获取参数
        char argInfo[512] = {};
        unsigned int argCount = method_getNumberOfArguments(method);
        for (int j = 0; j < argCount; j ++) {
            // 参数类型
            method_getArgumentType(method, j, argInfo, 512);
            NSLog(@"参数类型= %s", argInfo);
            memset(argInfo, '\0', strlen(argInfo));
            
        }
        // 获取方法返回值类型
        char retType[512] = {};
        method_getReturnType(method, retType, 512);
        NSLog(@"返回类型值类型= %s", retType);
        
    }
    
    free(methods);
}

@end
