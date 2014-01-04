package test;

public class StringHandlingTest extends TestCase {
	public void testSimple() {
		String hello = "Hello";
		String world = "World";
		String helloWorld = hello + world;

		assertTrue(helloWorld.equals("HelloWorld"));
	}
}
