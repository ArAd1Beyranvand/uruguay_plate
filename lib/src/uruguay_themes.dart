import 'package:flutter/widgets.dart' show Color;
import 'package:plate_core/plate_core.dart';

import 'uruguay_colors.dart';

/// One ink on one field, the frame in the ink's colour. Border and corner are
/// estimated from the photographs (thin embossed frame, small radius), not
/// measured.
///
/// The truck, rental, diplomatic and Mercosur plates are black on white and
/// the yellow categories share one theme, so each is an alias.
abstract final class UruguayThemes {
  static final PlateTheme private = _framed(UruguayColors.white, UruguayColors.black);
  static final PlateTheme official = _framed(UruguayColors.white, UruguayColors.blue);
  static final PlateTheme medical = _framed(UruguayColors.white, UruguayColors.green);
  static final PlateTheme assembly = _framed(UruguayColors.assemblyBlue, UruguayColors.white);

  /// The face is the dark top; the light bottom is a background section.
  static final PlateTheme president = _framed(UruguayColors.presidentDark, UruguayColors.white);
  static final PlateTheme yellow = _framed(UruguayColors.yellow, UruguayColors.black);
  static final PlateTheme truck = private;
  static final PlateTheme rental = private;
  static final PlateTheme diplomatic = private;
  static final PlateTheme mercosur = private;
}

PlateTheme _framed(Color field, Color ink) => PlateTheme.monochrome(
  field: field,
  ink: ink,
  inactive: UruguayColors.inactive,
  borderWidthRatio: 0.02,
  plateRadiusRatio: 0.06,
);
