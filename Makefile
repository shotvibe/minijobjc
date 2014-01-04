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
	       IOSArray.m \
	       IOSArrayClass.m \
	       IOSBooleanArray.m \
	       IOSByteArray.m \
	       IOSCharArray.m \
	       IOSClass.m \
	       IOSConcreteClass.m \
	       IOSDoubleArray.m \
	       IOSFloatArray.m \
	       IOSIntArray.m \
	       IOSLongArray.m \
	       IOSMappedClass.m \
	       IOSObjectArray.m \
	       IOSPrimitiveClass.m \
	       IOSProtocolClass.m \
	       IOSReflection.m \
	       IOSShortArray.m \
	       JavaLangReflectTypeVariableImpl.m \
	       JavaLangThrowable.m \
	       JavaMetadata.m \
	       JreEmulation.m \
	       JreMemDebug.m \
	       JreMemDebugStrongReference.m \
	       NSObject+JavaObject.m \

RUNTIME_OBJS = $(RUNTIME_SRCS:%.m=build/%.o)

RUNTIME_JRE_SRCS = \
		    java/lang/ArrayIndexOutOfBoundsException.java \
		    java/lang/ArrayStoreException.java \
		    java/lang/AssertionError.java \
		    java/lang/Boolean.java \
		    java/lang/Byte.java \
		    java/lang/Character.java \
		    java/lang/ClassCastException.java \
		    java/lang/ClassNotFoundException.java \
		    java/lang/CloneNotSupportedException.java \
		    java/lang/Double.java \
		    java/lang/Enum.java \
		    java/lang/Error.java \
		    java/lang/Exception.java \
		    java/lang/Float.java \
		    java/lang/IllegalArgumentException.java \
		    java/lang/IllegalMonitorStateException.java \
		    java/lang/IllegalStateException.java \
		    java/lang/IndexOutOfBoundsException.java \
		    java/lang/Integer.java \
		    java/lang/InternalError.java \
		    java/lang/Long.java \
		    java/lang/NullPointerException.java \
		    java/lang/Reflect/GenericDeclaration.java \
		    java/lang/Reflect/Type.java \
		    java/lang/Reflect/TypeVariable.java \
		    java/lang/RuntimeException.java \
		    java/lang/Short.java \
		    java/lang/StackTraceElement.java \
		    java/lang/StringIndexOutOfBoundsException.java \

RUNTIME_JRE_FILES = $(RUNTIME_JRE_SRCS:%.java=src/jre/%.java)

RUNTIME_JRE_OBJS = $(RUNTIME_JRE_SRCS:%.java=build/jre/%.o)

build/objc-sync.o : src/objc-sync.m
	@mkdir -p build
	$(CLANG) -c $(CLANG_FLAGS) -fno-objc-arc -Iinclude $< -o $@

build/%.o : src/%.m src/* build/.j_codegen
	@mkdir -p build
	$(CLANG) -c $(CLANG_FLAGS) -Iinclude -Ibuild/jre $< -o $@

build/minijobjc.a : $(RUNTIME_OBJS) $(RUNTIME_JRE_OBJS) build/objc-sync.o
	$(LIBTOOL) -static -o $@ $^

build/.j_codegen : $(RUNTIME_JRE_FILES)
	$(J2OBJC) $(J2OBJC_FLAGS) -d build/jre $(RUNTIME_JRE_FILES)
	@touch build/.j_codegen

build/jre/%.m : build/.j_codegen
	@true

build/jre/%.o : build/jre/%.m
	$(CLANG) -c $(CLANG_FLAGS) -Ibuild -Ibuild/jre -Iinclude $< -o $@

# ----------------------------------------------------------------------------
# Test
# ----------------------------------------------------------------------------

TEST_NATIVE_SRCS = \
		 TestRunner.m \
		 HelloNativeTest.m \

TEST_NATIVE_OBJS = $(TEST_NATIVE_SRCS:%.m=build/test/native/%.o)

TEST_JAVA_SRCS = \
		 ArrayTest.java \
		 EnumTest.java \
		 ExceptionHandlingTest.java \
		 HelloTest.java \
		 StringHandlingTest.java \
		 TestCase.java \


TEST_JAVA_FILES = $(TEST_JAVA_SRCS:%.java=test/%.java)

TEST_JAVA_OBJS = $(TEST_JAVA_SRCS:%.java=build/test/%.o)

build/test/native/%.o : test/native/%.m test/native/* build/.test_codegen
	@mkdir -p build/test/native
	$(CLANG) -c $(CLANG_FLAGS) -Iinclude -Ibuild -Ibuild/jre $< -o $@

build/.test_codegen : $(TEST_JAVA_FILES)
	$(J2OBJC) $(J2OBJC_FLAGS) -d build $(TEST_JAVA_FILES)
	@touch build/.test_codegen

.SECONDARY :

build/test/%.m : build/.test_codegen
	@true

build/test/%.o : build/test/%.m
	$(CLANG) -c $(CLANG_FLAGS) -Ibuild -Ibuild/jre -Iinclude $< -o $@

build/test/TestRunner : $(TEST_NATIVE_OBJS) $(TEST_JAVA_OBJS) build/minijobjc.a
	$(CLANG) $(CLANG_FLAGS) $(CLANG_LINK_FLAGS) -force_load build/minijobjc.a $(TEST_NATIVE_OBJS) $(TEST_JAVA_OBJS) -o $@
