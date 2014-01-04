package test;

public class ExceptionHandlingTest extends TestCase {
	public void testThrowRuntimeException() {
		// Needed to make the java compiler happy
		if (true) {
			try {
				throw new RuntimeException();
			} catch (Exception ex) {
				return;
			}
		}

		// If we got here then it's bad
		assertTrue(false);
	}
}
