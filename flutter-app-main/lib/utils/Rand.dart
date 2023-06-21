import 'dart:math';

class Rand {
  static String generate(int length) {
    Random random = new Random(new DateTime.now().millisecond);

    final String hexDigits = "0123456789abcdef";
    final List<String> uuid = new List(length);

    for (int i = 0; i < length; i++) {
      final int hexPos = random.nextInt(16);
      uuid[i] = (hexDigits.substring(hexPos, hexPos + 1));
    }
    final StringBuffer buffer = new StringBuffer();
    buffer.writeAll(uuid);
    return buffer.toString();
  }
}
