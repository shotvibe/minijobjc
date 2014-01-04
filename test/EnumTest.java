package test;

public class EnumTest extends TestCase {
	public enum Color {
		RED,
		GREEN,
		BLUE
	}

	public void testColor() {
		Color red = Color.RED;
		Color blue = Color.BLUE;

		assertTrue(red == Color.RED);
		assertTrue(red != blue);
	}
}
