import 'package:flutter_test/flutter_test.dart';
import 'package:booking30shine/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty value', () {
      expect(Validators.email(''), isNotNull);
    });

    test('rejects missing @', () {
      expect(Validators.email('demo30shine.vn'), isNotNull);
    });

    test('accepts a valid email', () {
      expect(Validators.email('demo@30shine.vn'), isNull);
    });
  });

  group('Validators.phone', () {
    test('rejects a phone that is too short', () {
      expect(Validators.phone('0900'), isNotNull);
    });

    test('accepts a 10-digit phone starting with 0', () {
      expect(Validators.phone('0900000000'), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects password under 6 characters', () {
      expect(Validators.password('123'), isNotNull);
    });

    test('accepts password with 6+ characters', () {
      expect(Validators.password('123456'), isNull);
    });
  });
}
