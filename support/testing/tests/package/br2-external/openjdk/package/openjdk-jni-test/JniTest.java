public class JniTest
{
	private static void Test(
		String name,
		Object actual,
		Object expected,
		String actualAsString,
		String expectedAsString)
	{
		if (!actual.equals(expected))
		{
			System.out.println(String.format(
				"Test: %s failed\nExpected: \"%s\", Actual: \"%s\"",
				name,
				expected,
				actual));
			JniTest.exitCode = -1;
		}
		else
		{
			System.out.println(String.format("Test: %s passed", name));
		}
	}

	private static void Test(
		String name,
		String actual,
		String expected)
	{
		JniTest.Test(name, actual, expected, actual, expected);
	}

	public static void main(String[] args)
	{
		var actualVersion = JniWrapper.get_jni_version();
		var expectedVersion = 0x000A0000;
		JniTest.Test(
			"Get JNI Version",
			actualVersion,
			expectedVersion,
			String.format("0x%08X", actualVersion),
			String.format("0x%08X", expectedVersion));

		JniTest.Test(
			"Read Native String Constant",
			JniWrapper.read_constant_string(),
			"Hello from C");

		JniTest.Test(
			"Write Java String to Native Library",
			JniWrapper.write_string("Hello from Java"),
			"Hello from Java");

		JniTest.Test(
			"Write Java Char Array to Native Library",
			JniWrapper.write_char_array("Hello from Java".toCharArray()),
			"Hello from Java");

		var helper = new JniHelper();
		JniTest.Test(
			"Write String Member to Native Library",
			JniWrapper.write_string_member(helper),
			"Set from Java");

		JniWrapper.set_string_member(helper);
		JniTest.Test(
			"Set String Member from Native Library",
			helper.stringMember,
			"Set from C");

		JniWrapper.execute_java_function(helper);
		JniTest.Test(
			"Execeute Java Function from Native Library",
			helper.stringMember,
			"Hello, Managed World");

		helper = JniWrapper.instantiate_java_class();
		JniTest.Test(
			"Instantiate Java Class",
			helper.stringMember,
			"Instantiated from C");

		JniTest.Test(
			"Call Native Library to Set System Time",
			JniWrapper.set_and_write_time_in_seconds(1000),
			"1000");

		System.exit(exitCode);
	}

	public static int exitCode = 0;
}
