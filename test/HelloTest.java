package test;

public class HelloTest extends TestCase {
	public static long fib(long n) {
		if (n <= 1) {
			return n;
		} else {
			return fib(n - 1) + fib(n - 2);
		}
	}

	public static long fac(long n) {
		long result = 1;
		for (long i = 2; i <= n; ++i) {
			result *= i;
		}
		return result;
	}

	public void testFib() {
		assertEq(fib(1), 1);
		assertEq(fib(2), 1);
		assertEq(fib(3), 2);
		assertEq(fib(4), 3);
		assertEq(fib(5), 5);
		assertEq(fib(6), 8);
		assertEq(fib(7), 13);
		assertEq(fib(8), 21);
		assertEq(fib(20), 6765);
	}

	public void testFac() {
		assertEq(fac(1), 1);
		assertEq(fac(2), 2);
		assertEq(fac(3), 6);
		assertEq(fac(4), 24);
		assertEq(fac(5), 120);
		assertEq(fac(6), 720);
		assertEq(fac(11), 39916800);
	}
}
