//
//  SharedFileOperator.h
//  batchPhoneBlock
//
//  Created by legend on 2017/9/13.
//  Copyright © 2017年 legend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedFileOperator : NSObject

-(SharedFileOperator *_Nonnull)initWithSuiteName:suiteName fileName:(NSString *_Nonnull)fileName;

- (nullable id)valueForKey:(NSString *_Nonnull)key;

- (void)setValue:(nullable id)value forKey:(NSString *_Nonnull)key;

- (void)removeObjectForKey:(NSString *_Nonnull)aKey;

- (BOOL)synchronize;

@property (strong, nonatomic) NSString * _Nonnull  filePath;

@property (strong, nonatomic) NSMutableDictionary * _Nullable dict;


@end
