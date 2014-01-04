package test;

public class ArrayTest extends TestCase {
	public static int sum(int[] arr) {
		int sum = 0;
		for (int x : arr) {
			sum += x;
		}

		return sum;
	}

	public void testSum() {
		int vals[] = { 1, 2, 3, 5, 0, 1 };

		assertTrue(sum(vals) == 12);
	}
}
