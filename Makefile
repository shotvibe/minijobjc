# ----------------------------------------------------------------------------
#
# miniobjc
#
# ----------------------------------------------------------------------------

all : \
	check_requirements \
	build/minijobjc.a \
	build/test/TestRunner \


# ----------------------------------------------------------------------------
# Environment
# ----------------------------------------------------------------------------

CLANG = clang
LIBTOOL = libtool
J2OBJC ?= j2objc

check_requirements : J2OBJC_exists

J2OBJC_exists :
	@which $(J2OBJC) > /dev/null || (echo "j2objc executable not found. set the J2OBJC environment var" ; false)

J2OBJC_FLAGS = -use-arc
CLANG_FLAGS = -fobjc-arc
CLANG_LINK_FLAGS = -framework Foundation


clean :
	rm -rf build

# ----------------------------------------------------------------------------
# The Mini Runtime
# ----------------------------------------------------------------------------

RUNTIME_SRCS = \
	       JavaLangException.m \
	       JavaLangNullPointerException.m \
	       JavaLangRuntimeException.m \
	       JavaLangThrowable.m \
	       JreEmulation.m \
	       JreMemDebug.m \


RUNTIME_OBJS = $(RUNTIME_SRCS:%.m=build/%.o)

build/%.o : src/%.m src/*
	@mkdir -p build
	$(CLANG) -c $(CLANG_FLAGS) -Iinclude $< -o $@

build/minijobjc.a : $(RUNTIME_OBJS)
	$(LIBTOOL) -static -o $@ $^


# ----------------------------------------------------------------------------
# Test
# ----------------------------------------------------------------------------

TEST_NATIVE_SRCS = \
		 TestRunner.m


TEST_NATIVE_OBJS = $(TEST_NATIVE_SRCS:%.m=build/test/native/%.o)

TEST_JAVA_SRCS = \
		 ExceptionHandlingTest.java \
		 HelloTest.java \
		 StringHandlingTest.java \
		 TestCase.java \


TEST_JAVA_FILES = $(TEST_JAVA_SRCS:%.java=test/%.java)

TEST_JAVA_OBJS = $(TEST_JAVA_SRCS:%.java=build/test/%.o)

build/test/native/%.o : test/native/%.m test/native/* build/.test_codegen
	@mkdir -p build/test/native
	$(CLANG) -c $(CLANG_FLAGS) -Iinclude -Ibuild $< -o $@

build/.test_codegen : $(TEST_JAVA_FILES)
	$(J2OBJC) $(J2OBJC_FLAGS) -d build $(TEST_JAVA_FILES)
	@touch build/.test_codegen

.SECONDARY :

build/test/%.m : build/.test_codegen
	@true

build/test/%.o : build/test/%.m
	$(CLANG) -c $(CLANG_FLAGS) -Ibuild -Iinclude $< -o $@

build/test/TestRunner : $(TEST_NATIVE_OBJS) $(TEST_JAVA_OBJS) build/minijobjc.a
	$(CLANG) $(CLANG_FLAGS) $(CLANG_LINK_FLAGS) $^ -o $@
