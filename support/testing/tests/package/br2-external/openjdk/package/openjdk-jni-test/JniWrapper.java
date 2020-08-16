public class JniWrapper
{
	static
	{
		System.loadLibrary("jni_native");
	}

	public static native int get_jni_version();
	public static native String read_constant_string();
	public static native String write_string(String string);
	public static native String write_char_array(char[] string);
	public static native String write_string_member(JniHelper helper);
	public static native void set_string_member(JniHelper helper);
	public static native void execute_java_function(JniHelper helper);
	public static native JniHelper instantiate_java_class();
	public static native String set_and_write_time_in_seconds(int seconds);
}
