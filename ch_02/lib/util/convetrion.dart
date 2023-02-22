enum Unit {
  meters,
  kilometers,
  grams,
  kilograms,
  feet,
  miles,
  pounds,
  ounces,
}

class Converter {
  final Map<Unit, List<double>> coefficients = {
    // length    [meters, kilometers, feet, miles]
    Unit.meters: [1, 0.001, 3.28084, 0.000621371],
    Unit.kilometers: [1000, 1, 3280.84, 0.621371],
    Unit.feet: [0.3048, 0.0003048, 1, 0.000189394],
    Unit.miles: [1609.34, 1.60934, 5280, 1],
    // weight   [grams, kilograms, pounds, ounces]
    Unit.grams: [1, 0.0001, 0.00220462, 0.035274],
    Unit.kilograms: [1000, 1, 2.20462, 35.274],
    Unit.pounds: [453.592, 0.453592, 1, 16],
    Unit.ounces: [28.3495, 0.0283495, 0.0625, 1],
  };

  late final List<Unit> keys = coefficients.keys.toList();
  late final int halfLength = keys.length ~/ 2;

  List<Unit> availableUnits(Unit startUnit) {
    final int startIndex = keys.indexOf(startUnit);
    final halfList = startIndex < halfLength
        ? keys.sublist(0, halfLength)
        : keys.sublist(halfLength);
    halfList.remove(startUnit);
    return halfList;
  }

  double convert({
    required double value,
    required Unit startUnit,
    required Unit convertedUnit,
  }) {
    final int startIndex = keys.indexOf(startUnit);
    final int convertedIndex = keys.indexOf(convertedUnit);

    if (startIndex < halfLength && convertedIndex < halfLength ||
        startIndex >= halfLength && convertedIndex >= halfLength) {
      final coefficient = coefficients[startUnit]![convertedIndex % halfLength];
      return value * coefficient;
    } else {
      return -1;
    }
  }
}
