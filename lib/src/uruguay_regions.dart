import 'package:plate_core/plate_core.dart';

/// Locates a Uruguayan plate from its leading department letter.
///
/// Source: the "Departmental coding" section of
/// https://en.wikipedia.org/wiki/Vehicle_registration_plates_of_Uruguay
abstract final class UruguayRegions {
  static const Map<String, String> _departments = <String, String>{
    'G': 'Artigas',
    'A': 'Canelones',
    'E': 'Cerro Largo',
    'L': 'Colonia',
    'Q': 'Durazno',
    'N': 'Flores',
    'O': 'Florida',
    'P': 'Lavalleja',
    'B': 'Maldonado',
    'S': 'Montevideo',
    'I': 'Paysandú',
    'J': 'Río Negro',
    'F': 'Rivera',
    'C': 'Rocha',
    'H': 'Salto',
    'M': 'San José',
    'K': 'Soriano',
    'R': 'Tacuarembó',
    'D': 'Treinta y Tres',
  };

  /// The department of [letter], or null when empty or unissued.
  static String? lookup(String letter) => _departments[letter.toUpperCase()];

  /// A [PlateLabelResolver] for [PlateSpec.resolveRegion].
  static String? captionOf(String Function(String key) group) {
    final String first = group('first');
    return first.isEmpty ? null : lookup(first[0]);
  }
}
