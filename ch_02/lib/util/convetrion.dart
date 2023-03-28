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
  final Map<String, List<double>> coefficients = {
    // length    [meters, kilometers, feet, miles]
    'meters': [1, 0.001, 3.28084, 0.000621371],
    'kilometers': [1000, 1, 3280.84, 0.621371],
    'feet': [0.3048, 0.0003048, 1, 0.000189394],
    'miles': [1609.34, 1.60934, 5280, 1],
    // weight   [grams, kilograms, pounds, ounces]
    'grams': [1, 0.0001, 0.00220462, 0.035274],
    'kilograms': [1000, 1, 2.20462, 35.274],
    'pounds(lbs)': [453.592, 0.453592, 1, 16],
    'ounces': [28.3495, 0.0283495, 0.0625, 1],
  };

  late final labels = coefficients.keys.toList();

  List<String> convert({
    required double value,
    required String measure,
  }) {
    final int measureIndex = labels.indexOf(measure);
    final List<String> result = [];

    final int loopIndex = measureIndex < 4 ? 0 : 4;
    if (value == 0) {
      for (int i = loopIndex; i < loopIndex + 4; i++) {
        result.add(labels[i].toString());
        result.add('0');
      }
      return result;
    } else {
      final multipliers = coefficients[measure]!;
      for (int i = loopIndex; i < loopIndex + 4; i++) {
        result.add(labels[i].toString());
        result.add('${value * multipliers[i % 4]}');
      }
      return result;
    }
  }
}
