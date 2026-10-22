import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uruguay_plate/uruguay_plate.dart';
import 'package:plate_core/plate_core.dart';

/// One golden per category, drawn with real bold faces so the ink can be
/// measured against the references (`platekit golden-check`).
///
/// Regenerate with `flutter test --update-goldens` after a deliberate change.
void main() {
  setUpAll(() async {
    final FontLoader loader = FontLoader('Roboto');
    for (final String path in const <String>[
      '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
    ]) {
      final File face = File(path);
      if (!face.existsSync()) continue;
      loader.addFont(face.readAsBytes().then((b) => ByteData.view(b.buffer)));
    }
    await loader.load();
  });

  /// category id -> (spec, theme, space-separated sample value)
  final Map<String, (PlateSpec, PlateTheme, String)> cases =
      <String, (PlateSpec, PlateTheme, String)>{
        'private': (UruguayPlates.private, UruguayThemes.private, 'L AA 2821'),
        'official': (UruguayPlates.official, UruguayThemes.official, 'S OF 1057'),
        'ambulance': (UruguayPlates.ambulance, UruguayThemes.medical, 'L AM 1032'),
        'doctor': (UruguayPlates.doctor, UruguayThemes.medical, 'L ME 1096'),
        'assembly': (UruguayPlates.assembly, UruguayThemes.assembly, 'L ED 0028'),
        'president': (UruguayPlates.president, UruguayThemes.president, 'L PE 1'),
        'remise': (UruguayPlates.remise, UruguayThemes.yellow, 'L RE 1058'),
        'taxi': (UruguayPlates.taxi, UruguayThemes.yellow, 'L TX 1009'),
        'transport': (UruguayPlates.publicTransport, UruguayThemes.yellow, 'L TC 1033'),
        'school': (UruguayPlates.school, UruguayThemes.yellow, 'L ES 1234'),
        'tourist': (UruguayPlates.tourist, UruguayThemes.yellow, 'L MT 1002'),
        'truck': (UruguayPlates.truck, UruguayThemes.truck, 'A TP 1234'),
        'rental': (UruguayPlates.rental, UruguayThemes.rental, 'L AL 1209'),
        'diplomatic': (UruguayPlates.diplomatic, UruguayThemes.diplomatic, 'S CD 1234'),
        'private_short': (UruguayPlates.private, UruguayThemes.private, 'L AA 21'),
        'mercosur': (UruguayPlates.mercosur, UruguayThemes.mercosur, 'B GA 0406'),
      };

  for (final MapEntry<String, (PlateSpec, PlateTheme, String)> c in cases.entries) {
    testWidgets(c.key, (tester) async {
      final (PlateSpec spec, PlateTheme theme, String values) = c.value;
      final PlateController controller = PlateController.fromValues(spec, values.split(' '));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 680,
                height: 300,
                child: PlateThemeScope(
                  theme: theme,
                  child: PlateView(
                    controller: controller,
                    theme: theme,
                    country: UruguayCountry.uruguay,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(find.byType(PlateView), matchesGoldenFile('goldens/uy_${c.key}.png'));
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }

  test('the number completes from one digit', () {
    final PlateController controller = PlateController.fromValues(UruguayPlates.private, <String?>[
      'L',
      'AA',
      '2',
    ]);
    expect(controller.isCompleted, isTrue);
    controller.setAt(2, '');
    expect(controller.isCompleted, isFalse);
    controller.dispose();
  });
}
