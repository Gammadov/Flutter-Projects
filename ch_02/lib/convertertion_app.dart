import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:converter_app/util/convetrion.dart';

class MyConversionApp extends StatefulWidget {
  const MyConversionApp({super.key});

  @override
  State<MyConversionApp> createState() => _MyConversionAppState();
}

class _MyConversionAppState extends State<MyConversionApp> {
  String _textNumber = '';
  String _answer = '';
  Unit? _startUnit;
  Unit? _convertedUnit;

  final Converter converter = Converter();

  final Map<Unit, String> measures = {
    Unit.meters: 'meters',
    Unit.kilometers: 'kilometers',
    Unit.grams: 'grams',
    Unit.kilograms: 'kilograms',
    Unit.feet: 'feet',
    Unit.miles: 'miles',
    Unit.pounds: 'pounds(lbs)',
    Unit.ounces: 'ounces',
  };

  final TextStyle inputStyle = TextStyle(fontSize: 20, color: Colors.blue[900]);

  final TextStyle labelStyle = TextStyle(
    fontSize: 24,
    color: Colors.grey[700],
  );

  @override
  Widget build(BuildContext context) {
    double sizeX = MediaQuery.of(context).size.width;
    double sizeY = MediaQuery.of(context).size.height;
    final spacer = SizedBox(height: sizeY / 40);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Measures Converter'),
      ),
      body: Container(
        width: sizeX,
        padding: EdgeInsets.all(sizeX / 20),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Text(
              'Value',
              style: labelStyle,
            ),
            spacer,
            TextField(
              style: inputStyle,
              decoration: const InputDecoration(
                hintText: "Please insert the measure to be converted",
              ),
              // keyboardType: TextInputType.number,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),

              // Only numbers can be entered
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]+[.]{0,1}[0-9]*'),
                ),
              ],
              onChanged: (text) {
                if (text.isNotEmpty) {
                  setState(
                    () {
                      _textNumber = text;
                    },
                  );
                }
              },
            ),
            spacer,
            Text(
              'From',
              style: labelStyle,
            ),
            spacer,
            DropdownButton<Unit>(
              isExpanded: true,
              style: inputStyle,
              value: _startUnit,
              items: List.generate(Unit.values.length, (index) {
                final unit = Unit.values[index];
                return DropdownMenuItem<Unit>(
                  value: unit,
                  child: Text(
                    measures[unit]!,
                    style: inputStyle,
                  ),
                );
              }),
              onChanged: (value) {
                onStartMeasureChanged(value!);
              },
            ),
            spacer,
            Text(
              'To',
              style: labelStyle,
            ),
            spacer,
            DropdownButton<Unit>(
              isExpanded: true,
              style: inputStyle,
              value: _convertedUnit,
              items: availableItems(
                converter: converter,
                start: _startUnit ?? Unit.meters,
              ),
              onChanged: _startUnit == null
                  ? null
                  : (value) {
                      onConvertedMeasureChanged(value!);
                    },
              disabledHint: const Text('first select the From unit'),
            ),
            spacer,
            ElevatedButton(
              child: const Text(
                'Convert',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () => convert(
                converter: converter,
                startUnit: _startUnit,
                convertedUnit: _convertedUnit,
              ),
            ),
            spacer,
            Text(
              _answer,
              style: labelStyle,
            )
          ],
        )),
      ),
    );
  }

  void onStartMeasureChanged(Unit value) {
    setState(() {
      _startUnit = value;
      _convertedUnit = null;
      _answer = '';
    });
  }

  List<DropdownMenuItem<Unit>> availableItems({
    required Unit start,
    required Converter converter,
  }) {
    final available = converter.availableUnits(start);

    return List.generate(
      available.length,
      (index) {
        return DropdownMenuItem<Unit>(
          value: available[index],
          child: Text(
            measures[available[index]]!,
            style: inputStyle,
          ),
        );
      },
    );
  }

  void onConvertedMeasureChanged(Unit value) {
    setState(() {
      _convertedUnit = value;
    });
  }

  void convert({
    required Converter converter,
    required Unit? startUnit,
    required Unit? convertedUnit,
  }) {
    if (_textNumber.isEmpty || startUnit == null || convertedUnit == null) {
      return;
    }

    double result = converter.convert(
        value: double.parse(_textNumber),
        startUnit: startUnit,
        convertedUnit: convertedUnit);
    if (result <= 0) {
      setState(() => _answer = 'This conversion cannot be performed');
    } else {
      setState(() => _answer =
          '$_textNumber ${measures[startUnit]} are $result ${measures[convertedUnit]}');
    }
  }
}
