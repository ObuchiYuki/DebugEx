//
//  ExceptionHanlder.m
//  CoreUtil
//
//  Created by yuki on 2021/06/26.
//  Copyright © 2021 yuki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _ExceptionHandler : NSObject
+ (void)objc_try:(nonnull void(^)(void))objc_try
      objc_catch:(nonnull void(^)(NSException* _Nonnull))objc_catch
    objc_finally:(nullable void(^)(void))objc_finally;
@end

