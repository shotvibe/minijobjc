package test;

public class TestCase {
	@SuppressWarnings("serial")
	public static class TestFailureException extends RuntimeException {
		public TestFailureException(String message) {
			this.message = message;
		}

		public String getMessage() {
			return message;
		}

		private String message;
	}

	public void setUp() {
		// Default empty
	}

	public void tearDown() {
		// Default empty
	}

	public void assertEq(long a, long b) {
		if (a == b) {
			return;
		}

		throw new TestFailureException(a + " != " + b);
	}

	public void assertTrue(boolean value) {
		if (!value) {
			throw new TestFailureException("assertTrue failure");
		}
	}
}
