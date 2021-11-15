import 'package:test/test.dart';
import 'package:uno/uno.dart';

void main() {
  test('copyWith', () async {
    final request = Request(
      uri: Uri.parse('uri'),
      method: 'method',
      headers: {},
      timeout: Duration(seconds: 30),
    );
    final copy = request.copyWith();
    expect(request != copy, true);
  });
}
