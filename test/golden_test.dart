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
  final Map<String, (PlateSpec, PlateTheme, String)>
  cases = <String, (PlateSpec, PlateTheme, String)>{
    'private': (UruguayPlates.private, UruguayThemes.private, 'L A A 2 8 2 1'),
    'official': (
      UruguayPlates.official,
      UruguayThemes.official,
      'S O F 1 0 5 7',
    ),
    'ambulance': (
      UruguayPlates.ambulance,
      UruguayThemes.medical,
      'L A M 1 0 3 2',
    ),
    'doctor': (UruguayPlates.doctor, UruguayThemes.medical, 'L M E 1 0 9 6'),
    'assembly': (
      UruguayPlates.assembly,
      UruguayThemes.assembly,
      'L E D 0 0 2 8',
    ),
    'president': (UruguayPlates.president, UruguayThemes.president, 'L P E 1'),
    'remise': (UruguayPlates.remise, UruguayThemes.yellow, 'L R E 1 0 5 8'),
    'taxi': (UruguayPlates.taxi, UruguayThemes.yellow, 'L T X 1 0 0 9'),
    'transport': (
      UruguayPlates.publicTransport,
      UruguayThemes.yellow,
      'L T C 1 0 3 3',
    ),
    'school': (UruguayPlates.school, UruguayThemes.yellow, 'L E S 1 2 3 4'),
    'tourist': (UruguayPlates.tourist, UruguayThemes.yellow, 'L M T 1 0 0 2'),
    'truck': (UruguayPlates.truck, UruguayThemes.truck, 'A T P 1 2 3 4'),
    'rental': (UruguayPlates.rental, UruguayThemes.rental, 'L A L 1 2 0 9'),
    'diplomatic': (
      UruguayPlates.diplomatic,
      UruguayThemes.diplomatic,
      'S C D 1 2 3 4',
    ),
    'mercosur': (
      UruguayPlates.mercosur,
      UruguayThemes.mercosur,
      'B G A 0 4 0 6',
    ),
  };

  for (final MapEntry<String, (PlateSpec, PlateTheme, String)> c
      in cases.entries) {
    testWidgets(c.key, (tester) async {
      final (PlateSpec spec, PlateTheme theme, String values) = c.value;
      final PlateController controller = PlateController.fromValues(
        spec,
        values.split(' '),
      );
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
      await expectLater(
        find.byType(PlateView),
        matchesGoldenFile('goldens/uy_${c.key}.png'),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }
}
