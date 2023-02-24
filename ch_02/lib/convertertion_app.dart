import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:converter_app/util/convetrion.dart';

class MyConversionApp extends StatefulWidget {
  const MyConversionApp({super.key});

  @override
  State<MyConversionApp> createState() => _MyConversionAppState();
}

class _MyConversionAppState extends State<MyConversionApp> {
  double _inputNumber = 0;
  String _answer = '';
  Unit? _startUnit;
  Unit? _convertedUnit;

  final _numberController = TextEditingController();

  final Converter _converter = Converter();

  final Map<Unit, String> _measures = {
    Unit.meters: 'meters',
    Unit.kilometers: 'kilometers',
    Unit.grams: 'grams',
    Unit.kilograms: 'kilograms',
    Unit.feet: 'feet',
    Unit.miles: 'miles',
    Unit.pounds: 'pounds(lbs)',
    Unit.ounces: 'ounces',
  };

  final TextStyle _inputStyle =
      TextStyle(fontSize: 20, color: Colors.blue[900]);

  final TextStyle _labelStyle = TextStyle(
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
              style: _labelStyle,
            ),
            spacer,
            Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  setState(
                    () {
                      _inputNumber = double.parse(_numberController.text);
                      _numberController.text = _inputNumber.toString();
                    },
                  );
                }
              },
              child: TextField(
                controller: _numberController,
                style: _inputStyle,
                decoration: const InputDecoration(
                  hintText: "Please insert the measure to be converted",
                ),
                // keyboardType: TextInputType.number,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]+[.]{0,1}[0-9]*'),
                  ),
                ],
                onTap: () {
                  _inputNumber = 0;
                  _numberController.clear();
                },
              ),
            ),
            spacer,
            Text(
              'From',
              style: _labelStyle,
            ),
            spacer,
            DropdownButton<Unit>(
              isExpanded: true,
              style: _inputStyle,
              value: _startUnit,
              items: List.generate(Unit.values.length, (index) {
                final unit = Unit.values[index];
                return DropdownMenuItem<Unit>(
                  value: unit,
                  child: Text(
                    _measures[unit]!,
                    style: _inputStyle,
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
              style: _labelStyle,
            ),
            spacer,
            DropdownButton<Unit>(
              isExpanded: true,
              style: _inputStyle,
              value: _convertedUnit,
              items: availableItems(
                converter: _converter,
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
                converter: _converter,
                startUnit: _startUnit,
                convertedUnit: _convertedUnit,
              ),
            ),
            spacer,
            Text(
              _answer,
              style: _labelStyle,
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
            _measures[available[index]]!,
            style: _inputStyle,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
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
    if (_inputNumber == 0 || startUnit == null || convertedUnit == null) {
      return;
    }

    double result = converter.convert(
        value: _inputNumber,
        startUnit: startUnit,
        convertedUnit: convertedUnit);
    if (result <= 0) {
      setState(() => _answer = 'This conversion cannot be performed');
    } else {
      setState(() => _answer =
          '$_inputNumber ${_measures[startUnit]} are $result ${_measures[convertedUnit]}');
    }
  }
}
