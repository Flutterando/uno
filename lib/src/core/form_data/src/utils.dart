import 'dart:math';

String generateBoundary() {
  var random = Random();

  var boundary = '--------------------------';

  for (var i = 0; i < 24; i++) {
    boundary += random.nextInt(10).toString();
  }

  return boundary;
}
