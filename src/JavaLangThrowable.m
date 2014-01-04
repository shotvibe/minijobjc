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
//  Throwable.m
//  JreEmulation
//
//  Created by Tom Ball on 6/21/11, using j2objc.
//

#import "JreEmulation.h"
#import "JreMemDebug.h"
#import "IOSObjectArray.h"
#import "java/lang/Throwable.h"
//#import "java/lang/AssertionError.h"
//#import "java/lang/IllegalStateException.h"
//#import "java/lang/IllegalArgumentException.h"

#import <TargetConditionals.h>
#import <execinfo.h>

#ifndef MAX_STACK_FRAMES
// This defines the upper limit of the stack frames for any exception.
#define MAX_STACK_FRAMES 128
#endif

@implementation JavaLangThrowable

// This init message implementation is hand-modified to
// invoke NSException.initWithName:reason:userInfo:.  This
// is necessary so that JRE exceptions can be caught by
// class name.
- (id)initJavaLangThrowableWithNSString:(NSString *)message
                  withJavaLangThrowable:(JavaLangThrowable *)causeArg {
  if ((self = [super initWithName:[[self class] description]
                           reason:message
                         userInfo:nil])) {
    JreMemDebugAdd(self);
    cause = RETAIN_(causeArg);
    detailMessage = RETAIN_(message);
    suppressedExceptions = nil;
  }
  return self;
}

- (id)init {
  return [self initJavaLangThrowableWithNSString:nil withJavaLangThrowable:nil];
}

- (id)initWithNSString:(NSString *)message {
  return [self initJavaLangThrowableWithNSString:message withJavaLangThrowable:nil];
}

- (id)initWithNSString:(NSString *)message
    withJavaLangThrowable:(JavaLangThrowable *)causeArg {
  return [self initJavaLangThrowableWithNSString:message withJavaLangThrowable:causeArg];
}

- (id)initWithJavaLangThrowable:(JavaLangThrowable *)causeArg {
  return [self initJavaLangThrowableWithNSString:causeArg ? [causeArg description] : nil
                           withJavaLangThrowable:causeArg];
}

- (id)initWithNSString:(NSString *)message
 withJavaLangThrowable:(JavaLangThrowable *)causeArg
           withBoolean:(BOOL)enableSuppression
           withBoolean:(BOOL)writeableStackTrace {
  return [self initJavaLangThrowableWithNSString:message
                           withJavaLangThrowable:causeArg];
}

- (JavaLangThrowable *)getCause {
  return cause;
}

- (NSString *)getLocalizedMessage {
  return [self getMessage];
}

- (NSString *)getMessage {
  return detailMessage;
}

- (IOSObjectArray *)getStackTrace {
  return stackTrace;
}

#if ! __has_feature(objc_arc)
- (void)dealloc {
  JreMemDebugRemove(self);
  [cause release];
  [detailMessage release];
  [stackTrace release];
  [super dealloc];
}
#endif

@end
