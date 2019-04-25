#include "jni_helper.h"
#include "native.h"

// Handles Java/C interop

jint get_jni_version(JNIEnv* env)
{
	return (*env)->GetVersion(env);
}
jstring read_constant_jstring(JNIEnv* env)
{
	return (*env)->NewStringUTF(env, read_constant_string());
}
static jstring read_internal_string_as_jstring(JNIEnv* env)
{
	return (*env)->NewStringUTF(env, read_internal_string());
}
jstring write_jstring(JNIEnv* env, jstring string)
{
	const char* utf8_string = (*env)->GetStringUTFChars(env, string, NULL);
	write_internal_string(utf8_string);

	(*env)->ReleaseStringUTFChars(env, string, utf8_string);
	return read_internal_string_as_jstring(env);
}
jstring write_jchar_array(JNIEnv* env, jcharArray chars)
{
	jsize length = (*env)->GetArrayLength(env, chars);
	jchar* body = (*env)->GetCharArrayElements(env, chars, NULL);
	jstring input = (*env)->NewString(env, body, length);
	jstring output = write_jstring(env, input);

	(*env)->ReleaseCharArrayElements(env, chars, body, JNI_ABORT);
	return output;
}
static jfieldID get_string_member_field(JNIEnv* env, jobject helper)
{
	jclass class = (*env)->GetObjectClass(env, helper);
	return (*env)->GetFieldID(env, class, "stringMember", "Ljava/lang/String;");
}
jstring write_string_member(JNIEnv* env, jobject helper)
{
	jfieldID fieldID = get_string_member_field(env, helper);
	jstring string = (*env)->GetObjectField(env, helper, fieldID);

	return write_jstring(env, string);
}
static void set_string_member_helper(JNIEnv* env, jobject helper, const char* utf8_string)
{
	jfieldID fieldID = get_string_member_field(env, helper);
	jstring string = (*env)->NewStringUTF(env, utf8_string);
	(*env)->SetObjectField(env, helper, fieldID, string);
}
void set_string_member(JNIEnv* env, jobject helper)
{
	char stringBuffer[256];
	write_external_string(stringBuffer, 256);
	set_string_member_helper(env, helper, stringBuffer);
}

typedef struct
{
	JNIEnv* env;
	jobject object;
	jmethodID methodID;
} method_parameters;
static void call_void_java_method(void* context)
{
	method_parameters* parameters = (method_parameters*)context;
	(*parameters->env)->CallVoidMethod(parameters->env, parameters->object, parameters->methodID);
}
void execute_java_function(JNIEnv* env, jobject helper)
{
	jclass class = (*env)->GetObjectClass(env, helper);
	jmethodID methodID = (*env)->GetMethodID(env, class, "HelloManagedWorld", "()V");

	method_parameters parameters = {env, helper, methodID};
	execute_function(call_void_java_method, (void*)&parameters);
}
jobject instantiate_java_class(JNIEnv* env)
{
	jclass class = (*env)->FindClass(env, "JniHelper");
	jmethodID methodID = (*env)->GetMethodID(env, class, "<init>", "()V");

	jobject object =(*env)->NewObject(env, class, methodID);
	set_string_member_helper(env, object, "Instantiated from C");
	return object;
}
jstring set_and_write_time_in_seconds(JNIEnv* env, jint seconds)
{
	set_time_in_seconds((int)seconds);
	write_internal_time_in_seconds();
	return read_internal_string_as_jstring(env);
}
