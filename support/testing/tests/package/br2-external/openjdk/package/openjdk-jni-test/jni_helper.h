#pragma once

#include <jni.h>

jint get_jni_version(JNIEnv* env);
jstring read_constant_jstring(JNIEnv* env);
jstring write_jstring(JNIEnv* env, jstring string);
jstring write_jchar_array(JNIEnv* env, jcharArray chars);
jstring write_string_member(JNIEnv* env, jobject helper);
void set_string_member(JNIEnv* env, jobject helper);
void execute_java_function(JNIEnv* env, jobject helper);
jobject instantiate_java_class(JNIEnv* env);
jstring set_and_write_time_in_seconds(JNIEnv* env, jint seconds);
