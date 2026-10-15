import 'package:flutter_test/flutter_test.dart';
import 'package:uruguay_plate/uruguay_plate.dart';

void main() {
  test('department letters resolve', () {
    expect(UruguayRegions.lookup('S'), 'Montevideo');
    expect(UruguayRegions.lookup('b'), 'Maldonado');
  });

  test('empty and unissued letters are null', () {
    expect(UruguayRegions.lookup(''), isNull);
    expect(UruguayRegions.lookup('X'), isNull);
    expect(UruguayRegions.captionOf((_) => ''), isNull);
    expect(UruguayRegions.captionOf((_) => 'SB'), 'Montevideo');
  });
}
