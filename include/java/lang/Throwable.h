// Copyright 2011 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  Throwable.h
//  JreEmulation
//
//  Created by Tom Ball on 6/21/11, using j2objc.
//

#ifndef _JavaLangThrowable_H_
#define _JavaLangThrowable_H_

#import <Foundation/Foundation.h>
#import "java/io/Serializable.h"

@interface JavaLangThrowable : NSException < JavaIoSerializable > {
 @private
  JavaLangThrowable *cause;
  NSString *detailMessage;
  IOSObjectArray *stackTrace;
  IOSObjectArray *suppressedExceptions;
}
- (id)init;
- (id)initWithNSString:(NSString *)message;
- (id)initWithNSString:(NSString *)message
 withJavaLangThrowable:(JavaLangThrowable *)cause;
- (id)initWithJavaLangThrowable:(JavaLangThrowable *)cause;
- (id)initWithNSString:(NSString *)message
 withJavaLangThrowable:(JavaLangThrowable *)cause
           withBoolean:(BOOL)enableSuppression
           withBoolean:(BOOL)writeableStackTrace;
- (JavaLangThrowable *)getCause;
- (NSString *)getLocalizedMessage;
- (NSString *)getMessage;
- (IOSObjectArray *)getStackTrace;
@end

#endif // _JavaLangThrowable_H_
