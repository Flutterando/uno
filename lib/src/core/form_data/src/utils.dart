import 'dart:math';

///The function [generateBoundary] it's the type string
String generateBoundary() {
  final random = Random();

  var boundary = '--------------------------';

  for (var i = 0; i < 24; i++) {
    // ignore: use_string_buffers
    boundary += random.nextInt(10).toString();
  }

  return boundary;
}
