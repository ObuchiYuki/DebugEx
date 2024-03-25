//
//  ExceptionHanlder.m
//  CoreUtil
//
//  Created by yuki on 2021/06/26.
//  Copyright © 2021 yuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ExceptionHanlder.h>

@implementation _ExceptionHandler : NSObject 
+ (void)objc_try:(void (^)(void))objc_try
      objc_catch:(void (^)(NSException*))objc_catch
    objc_finally:(void (^)(void))objc_finally {
    @try {
        objc_try();
    }
    
    @catch (NSException* exception) {
        objc_catch(exception);
    }

    @finally {
        if (objc_finally) {
            objc_finally();
        }
    }
}
@end
