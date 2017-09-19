//
//  SharedFileOperator.m
//  batchPhoneBlock
//
//  Created by legend on 2017/9/13.
//  Copyright © 2017年 legend. All rights reserved.
//

#import "SharedFileOperator.h"

@implementation SharedFileOperator

-(SharedFileOperator *_Nonnull)initWithSuiteName:suiteName fileName:(NSString *_Nonnull)fileName
{
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:suiteName];
    //文件路径
    containerURL = [containerURL URLByAppendingPathComponent:fileName];
    NSString* fileRoot = containerURL.path;
    self.filePath = fileRoot;
//    NSLog(@"file pth:%@",fileRoot);
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileRoot]){
        [@{} writeToFile: fileRoot atomically: YES];
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:fileRoot];
    self.dict = dict;
    return self;
}

- (nullable id)valueForKey:(NSString *_Nonnull)key
{
    return [self.dict objectForKey:key];
}

- (void)setValue:(nullable id)value forKey:(NSString *_Nonnull)key
{
    [self.dict setValue:value forKey:key];
}

- (void)removeObjectForKey:(NSString *_Nonnull)aKey
{
    [self.dict removeObjectForKey:aKey];
}

- (BOOL)synchronize
{
    NSLog(@"new self.dict :  %@",self.dict);
    return [self.dict writeToFile:self.filePath atomically:YES];
}


@end
