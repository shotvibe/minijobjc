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

	public void testSwitch() {
		Color c = Color.BLUE;

		int x = 0;
		switch (c) {
			case RED:
				x = 1;
				break;

			case BLUE:
				x = 2;
				break;

			case GREEN:
				x = 3;
				break;

			default:
				x = 4;
				break;
		}

		assertTrue(x == 2);
	}
}
