#include "JniWrapper.h"
#include "jni_helper.h"

// Proxies the generated function calls to the jni_helper

JNIEXPORT jint JNICALL Java_JniWrapper_get_1jni_1version
	(JNIEnv* env, jclass class)
{
	return get_jni_version(env);
}
JNIEXPORT jstring JNICALL Java_JniWrapper_read_1constant_1string
	(JNIEnv* env, jclass class)
{
	return read_constant_jstring(env);
}
JNIEXPORT jstring JNICALL Java_JniWrapper_write_1string
	(JNIEnv* env, jclass class, jstring string)
{
	return write_jstring(env, string);
}
JNIEXPORT jstring JNICALL Java_JniWrapper_write_1char_1array
	(JNIEnv* env, jclass class, jcharArray chars)
{
	return write_jchar_array(env, chars);
}
JNIEXPORT jstring JNICALL Java_JniWrapper_write_1string_1member
	(JNIEnv* env, jclass class, jobject helper)
{
	return write_string_member(env, helper);
}
JNIEXPORT void JNICALL Java_JniWrapper_set_1string_1member
	(JNIEnv* env, jclass class, jobject helper)
{
	set_string_member(env, helper);
}
JNIEXPORT void JNICALL Java_JniWrapper_execute_1java_1function
	(JNIEnv* env, jclass class, jobject helper)
{
	execute_java_function(env, helper);
}
JNIEXPORT jobject JNICALL Java_JniWrapper_instantiate_1java_1class
	(JNIEnv* env, jclass class)
{
	return instantiate_java_class(env);
}
JNIEXPORT jstring JNICALL Java_JniWrapper_set_1and_1write_1time_1in_1seconds
	(JNIEnv* env, jclass class, jint seconds)
{
	return set_and_write_time_in_seconds(env, seconds);
}
