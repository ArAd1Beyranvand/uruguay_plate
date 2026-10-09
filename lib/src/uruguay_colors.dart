import 'package:flutter/widgets.dart';

/// Colours of the Uruguayan plates, modal pixels of the colour-balanced flat
/// photographs (`.plateref/uy`): the official plate's blue ink `51639F`, the
/// ambulance and doctor green `21573F`, the remise yellow `FFC513`, the
/// departmental assembly's light blue `96DEFE`, the president's dark `214569`
/// over light `63B7F3`, and the Mercosur band `456FAB`. White faces and black
/// ink are the 2016 plate's `FCFCFC` and `1F2323`.
abstract final class UruguayColors {
  static const Color white = Color(0xFFFCFCFC);
  static const Color black = Color(0xFF1F2323);
  static const Color blue = Color(0xFF51639F);
  static const Color green = Color(0xFF21573F);
  static const Color yellow = Color(0xFFFFC513);
  static const Color assemblyBlue = Color(0xFF96DEFE);
  static const Color presidentDark = Color(0xFF214569);
  static const Color presidentLight = Color(0xFF63B7F3);
  static const Color mercosurBand = Color(0xFF456FAB);
  static const Color inactive = Color(0xFFB0B0B0);
}
