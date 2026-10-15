import 'dart:math';

import 'package:flutter/widgets.dart' show Color, EdgeInsets;
import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

import 'uruguay_colors.dart';
import 'uruguay_country.dart';

/// Where the ink sits, in plate units.
///
/// The canvas is the Mercosur size the article gives, 400×130 (the 2007 plates
/// are photographed at 3.0–3.1, close enough to share it). The references are
/// the flat photographs (2080×712, drawn by the offline stage in plate units
/// 500×166); x is scaled by 0.8 and y by 0.783.
///
/// Serial plate (2007, e.g. `LAA 2821`): ink y 12.2–123 → 9.6–96.3, letters
/// x 130–815 of 2080 → 25–157 (pitch 44), a gap for the Colonia crest, digits
/// x 1015–1950 → 195–376 (pitch 45). Caption row ink y 127–156 → 99.5–122,
/// centred x 195 (`URUGUAY` x 180–370 of 500 → 144–296). Ambulance and doctor
/// carry a cross at x 30–56, y 98–120.
///
/// Ink is about 55% of a box and the box cannot leave the canvas, so the
/// 86-unit serial ink is drawn at 106-box height (~58 ink, ~67%). The caption
/// meets its ~22 of ink with glyph 30–38 sized to fit the width.
///
/// Mercosur (2016): blue band y 0–38 (the photographed divider at 46.6 of 166
/// → 36.5), `URUGUAY` in white within it; letters x 27–157 and digits
/// x 199–375, serial ink y 48–120 against a 92-box (~51 ink, 70%).
///
/// Not drawn: the Colonia crest and corner shield on the 2007 plates (a
/// department's own, not part of the type), the Mercosur flag and logo, the
/// motorcycle plate (letters over digits, a different design), and the
/// pre-2000 departmental plates. The tourist-bus (white on blue) is left out
/// for want of a measured reference. The school, tourist, truck, rental and
/// diplomatic plates have no photograph here: they reuse the serial plate with
/// the table's caption and colours.
abstract final class _Layout {
  static const double width = 400;
  static const double height = 130;

  static const double serialTop = 2;
  static const double serialHeight = 106;
  static const double lettersLeft = 25;
  static const double lettersPitch = 44;
  static const double digitsRight = 376;
  static const double digitsPitch = 45;

  static const double captionCx = 195;
  static const double captionCy = 111;
  static const double captionWidth = 300;

  static const double mercosurBandEnd = 38;
  static const double mercosurTop = 38;
  static const double mercosurHeight = 92;
  static const double mercosurLettersLeft = 27;
  static const double mercosurLettersPitch = 43.5;
  static const double mercosurDigitsRight = 375;
  static const double mercosurDigitsPitch = 44;

  /// The president plate's dark top ends here: 0.62 of the height, read off
  /// the sheet, not measured.
  static const double presidentBandEnd = 80;
}

/// What varies between serial plates: the caption, its glyph size, and the
/// extras.
class _Serial {
  const _Serial(
    this.id,
    this.caption,
    this.glyph, {
    this.cross = false,
    this.digits = 4,
    this.background = PlateSection.plain,
  });

  final String id;
  final String caption;
  final double glyph;
  final bool cross;
  final int digits;
  final PlateSection background;
}

/// The Uruguayan plates. Serial plates are `A BC 1234`: groups `first` (three
/// letters, the first a department code) and `number`. Colour is a theme: see
/// `UruguayThemes`.
abstract final class UruguayPlates {
  static final PlateSpec private = _serial(
    const _Serial('uy.private', 'URUGUAY', 30),
  );
  static final PlateSpec official = _serial(
    const _Serial('uy.official', 'OFICIAL - URUGUAY', 32),
  );
  static final PlateSpec ambulance = _serial(
    const _Serial('uy.ambulance', 'URUGUAY', 30, cross: true),
  );
  static final PlateSpec doctor = _serial(
    const _Serial('uy.doctor', 'URUGUAY', 30, cross: true),
  );
  static final PlateSpec assembly = _serial(
    const _Serial('uy.assembly', 'EDIL JUNTA DEPARTAMENTAL', 26),
  );
  static final PlateSpec president = _serial(
    const _Serial(
      'uy.president',
      'PRESIDENTE J. DEPARTAMENTAL',
      26,
      digits: 1,
      background: PlateSection.rows(<PlatePart>[
        PlatePart(PlateSection.plain, end: _Layout.presidentBandEnd),
        PlatePart(
          PlateSection.fill(PlateFill.color(UruguayColors.presidentLight)),
        ),
      ]),
    ),
  );
  static final PlateSpec remise = _serial(
    const _Serial('uy.remise', 'REMISE', 30),
  );
  static final PlateSpec taxi = _serial(const _Serial('uy.taxi', 'TAXI', 30));
  static final PlateSpec publicTransport = _serial(
    const _Serial('uy.transport', 'URUGUAY', 30),
  );
  static final PlateSpec school = _serial(
    const _Serial('uy.school', 'ESCOLAR', 30),
  );
  static final PlateSpec tourist = _serial(
    const _Serial('uy.tourist', 'TURISMO - URUGUAY', 32),
  );
  static final PlateSpec truck = _serial(
    const _Serial('uy.truck', 'CARGA URUGUAY', 32),
  );
  static final PlateSpec rental = _serial(
    const _Serial('uy.rental', 'ALQUILER - URUGUAY', 32),
  );
  static final PlateSpec diplomatic = _serial(
    const _Serial('uy.diplomatic', 'URUGUAY', 30),
  );

  /// The 2016 Mercosur plate: a blue band with `URUGUAY` above the serial.
  static final PlateSpec mercosur = _mercosur();

  static List<PlateSpec> get all => <PlateSpec>[
    private,
    official,
    ambulance,
    doctor,
    assembly,
    president,
    remise,
    taxi,
    publicTransport,
    school,
    tourist,
    truck,
    rental,
    diplomatic,
    mercosur,
  ];

  static PlateSpec _serial(_Serial s) {
    final List<PlateSlot> slots = <PlateSlot>[
      ..._letters(
        _Layout.lettersLeft,
        _Layout.lettersPitch,
        _Layout.serialTop,
        _Layout.serialHeight,
      ),
      _digits(
        right: _Layout.digitsRight,
        pitch: _Layout.digitsPitch,
        top: _Layout.serialTop,
        height: _Layout.serialHeight,
        count: s.digits,
      ),
    ];
    return _spec(
      id: s.id,
      slots: slots,
      background: s.background,
      rules: s.cross
          ? const <PlateRule>[
              PlateRule(box: PlateBox(32, 105.5, 22, 7)),
              PlateRule(box: PlateBox(39.5, 98, 7, 22)),
            ]
          : const <PlateRule>[],
      labels: <PlateLabel>[
        PlateLabel(
          text: s.caption,
          box: PlateBox(
            _Layout.captionCx - _Layout.captionWidth / 2,
            _Layout.captionCy - 11,
            _Layout.captionWidth,
            22,
          ),
          glyphHeight: s.glyph,
        ),
      ],
    );
  }

  static PlateSpec _mercosur() {
    final List<PlateSlot> slots = <PlateSlot>[
      ..._letters(
        _Layout.mercosurLettersLeft,
        _Layout.mercosurLettersPitch,
        _Layout.mercosurTop,
        _Layout.mercosurHeight,
      ),
      _digits(
        right: _Layout.mercosurDigitsRight,
        pitch: _Layout.mercosurDigitsPitch,
        top: _Layout.mercosurTop,
        height: _Layout.mercosurHeight,
        count: 4,
      ),
    ];
    return _spec(
      id: 'uy.mercosur',
      slots: slots,
      background: const PlateSection.rows(<PlatePart>[
        PlatePart(
          PlateSection.fill(PlateFill.color(UruguayColors.mercosurBand)),
          end: _Layout.mercosurBandEnd,
        ),
        PlatePart(PlateSection.plain),
      ]),
      labels: const <PlateLabel>[
        PlateLabel(
          text: 'URUGUAY',
          box: PlateBox(100, 8, 200, 22),
          glyphHeight: 34,
          color: Color(0xFFFFFFFF),
        ),
      ],
    );
  }

  /// Three letters, the first a department code: two slots, because the
  /// first is drawn from a narrower alphabet.
  static List<PlateSlot> _letters(
    double left,
    double pitch,
    double top,
    double height,
  ) => <PlateSlot>[
    PlateSlot(
      alphabet: UruguayAlphabets.department,
      box: PlateBox(left, top, pitch, height),
      length: 1,
    ),
    PlateSlot(
      alphabet: UruguayAlphabets.letters,
      box: PlateBox(left + pitch, top, 2 * pitch, height),
      length: 2,
      spacing: max(0, pitch - 0.6 * 0.72 * height),
    ),
  ];

  /// The number, right-aligned to [right]; [count] is the most it holds, and
  /// it may be as short as one digit.
  static PlateSlot _digits({
    required double right,
    required double pitch,
    required double top,
    required double height,
    required int count,
  }) => PlateSlot(
    alphabet: UruguayAlphabets.digits,
    box: PlateBox(right - count * pitch, top, count * pitch, height),
    length: count,
    minLength: count > 1 ? 1 : null,
  );

  static PlateSpec _spec({
    required String id,
    required List<PlateSlot> slots,
    required PlateSection background,
    required List<PlateLabel> labels,
    List<PlateRule> rules = const <PlateRule>[],
  }) {
    return PlateSpec(
      id: id,
      country: UruguayCountry.uruguay,
      canvasWidth: _Layout.width,
      canvasHeight: _Layout.height,
      panel: const PlatePanel(
        box: PlateBox(0, 0, 0, _Layout.height),
        padding: EdgeInsets.zero,
      ),
      background: background,
      slots: slots,
      rules: rules,
      labels: labels,
      textGroups: <PlateTextGroup>[
        PlateTextGroup(<int>[0, 1], key: 'first'),
        PlateTextGroup(<int>[2], key: 'number'),
      ],
    );
  }
}
