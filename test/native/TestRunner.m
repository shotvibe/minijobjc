#import <objc/runtime.h>

#import <Foundation/Foundation.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#import <test/TestCase.h>

typedef struct {
	int numTests;
	int numFailures;
} TestCaseResult;

BOOL strStartsWith(const char *pre, const char *str)
{
	size_t lenpre = strlen(pre);
	size_t lenstr = strlen(str);
	return lenstr < lenpre ? NO : strncmp(pre, str, lenpre) == 0;
}

const char * TestMethodNamePrefix = "test";

TestCaseResult runTestCase(Class testCaseClass)
{
	const char *testCaseName = class_getName(testCaseClass);

	printf("\n--> Found TestCase: %s\n", testCaseName);

	TestCaseResult result;
	result.numTests = 0;
	result.numFailures = 0;

	TestTestCase *testCase = [[testCaseClass alloc] init];

	unsigned int count;
	Method *methods = class_copyMethodList(testCaseClass, &count);

	for (unsigned int i = 0; i < count; ++i) {
		SEL sel = method_getName(methods[i]);
		const char *methodName = sel_getName(sel);

		if (strStartsWith(TestMethodNamePrefix, methodName)) {
			[testCase setUp];

			printf("Running Test: %s.%s\n", testCaseName, methodName);

			result.numTests++;

			@try {
				// See this:
				//     http://stackoverflow.com/a/20058585
				((void (*)(id, SEL))[testCase methodForSelector:sel])(testCase, sel);
				printf("Ok\n");
			}
			@catch (TestTestCase_TestFailureException *exception) {
				result.numFailures++;

				printf("*** Test Failed: %s.%s\n", testCaseName, methodName);
				NSLog(@"%@", [exception getMessage]);
			}
			@catch (NSException *exception) {
				result.numFailures++;

				printf("*** Test Failed: %s.%s\n", testCaseName, methodName);
				NSLog(@"%@", exception.description);
			}

			[testCase tearDown];
		}
	}

	free(methods);

	return result;
}


int main()
{
	int numClasses = objc_getClassList(0, 0);
	Class *classes = (Class *)malloc(sizeof(Class) * numClasses);
	numClasses = objc_getClassList(classes, numClasses);

	int totalTests = 0;
	int totalFailures = 0;

	for (int i = 0; i < numClasses; ++i) {
		Class superClass = class_getSuperclass(classes[i]);

		if (superClass == [TestTestCase class]) {
			TestCaseResult result = runTestCase(classes[i]);
			totalTests += result.numTests;
			totalFailures += result.numFailures;
		}
	}

	free(classes);

	printf("\n");
	printf("---\n");

	printf("Total Tests: %d\n", totalTests);
	if (totalFailures == 0) {
		printf("All Ok!\n");
		return 0;
	}
	else {
		printf("Number of Failures: %d\n", totalFailures);
		return 2;
	}
}
