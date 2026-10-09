import 'package:plate_core/plate_core.dart';

/// Judges a Uruguayan serial `A BC 1234`: three letters in `first`, the first
/// a department code (A to S), and one to four digits in `number` (the
/// President of a Departmental Assembly's plate carries one).
///
/// The category is told by the last two letters (`OF` official, `AM`
/// ambulance, `ME` doctor, `ED` assembly, `PE` its president, `RE` remise,
/// `TX` taxi, `TC` public transport, `ES` school, `MT`/`TU` tourist, `TP`
/// truck, `AL` rental, `CD`/`CC` diplomatic); any letters pass. Reports, never
/// bars a keystroke.
class UruguayValidator extends GatedPlateValidator {
  const UruguayValidator();

  @override
  String get gateGroup => 'number';

  static const String reasonLetters =
      'A serial is three letters, the first a department code (A to S).';
  static const String reasonNumber = 'The number is one to four digits.';

  static final RegExp _letters = RegExp(r'^[A-S][A-Z]{2}$');
  static final RegExp _digits = RegExp(r'^[0-9]{1,4}$');

  @override
  PlateValidation judge(PlateEntry entry) {
    if (!_letters.hasMatch(entry.group('first'))) {
      return const PlateValidation.invalid(reasonLetters);
    }
    if (!_digits.hasMatch(entry.group('number'))) {
      return const PlateValidation.invalid(reasonNumber);
    }
    return const PlateValidation.valid();
  }
}
