import 'dart:math';

String generateCode() {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const digits = '0123456789';
  final random = Random();

  String generate() {
    final letterPart =
        List.generate(6, (_) => letters[random.nextInt(letters.length)]).join();
    final digitPart =
        List.generate(6, (_) => digits[random.nextInt(digits.length)]).join();
    return '$letterPart$digitPart';
  }

  return generate();
}
