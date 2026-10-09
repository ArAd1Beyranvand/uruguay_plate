import 'package:plate_core/plate_core.dart';

import 'uruguay_colors.dart';

/// Uruguay as a `PlateCountry`: no side panel and no flag. `URUGUAY` and the
/// category word are [PlateLabel]s on each spec, so [captionLines] is empty.
abstract final class UruguayCountry {
  static const PlateCountry uruguay = PlateCountry(
    code: 'uy',
    captionLines: <String>[],
    panelColor: UruguayColors.white,
    panelTextColor: UruguayColors.black,
  );
}
