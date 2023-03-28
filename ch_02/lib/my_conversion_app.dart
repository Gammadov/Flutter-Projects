import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:converter_app/util/convetrion.dart';

class MyConversionApp extends StatelessWidget {
  const MyConversionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const UnitConverter(),
    );
  }
}

class UnitConverter extends StatefulWidget {
  const UnitConverter({super.key});

  @override
  State<UnitConverter> createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  double _inputNumber = 0;
  Unit _unit = Unit.meters;

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
        title: const Text('Unit Converter'),
      ),
      body: Container(
        width: sizeX,
        padding: EdgeInsets.all(sizeX / 20),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  setState(
                    () {
                      _inputNumber = _numberController.text.isEmpty
                          ? 0
                          : double.parse(_numberController.text);
                      _numberController.text = _inputNumber.toString();
                    },
                  );
                }
              },
              child: TextField(
                controller: _numberController,
                // style: _inputStyle,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  // labelStyle:,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
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
            Row(
              children: [
                MenuAnchor(
                  builder: (context, controller, child) {
                    return FilledButton.tonal(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      child: Text(_measures[_unit].toString()),
                    );
                  },
                  menuChildren: List.generate(Unit.values.length, (index) {
                    final unit = Unit.values[index];
                    return MenuItemButton(
                      child: Text(
                        _measures[unit]!,
                        // style: _inputStyle,
                      ),
                      onPressed: () => onUnitChanged(unit),
                    );
                  }),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    'are',
                    // style: _labelStyle,
                  ),
                ),
              ],
            ),
            spacer,
            ...convert(measure: _measures[_unit]!),
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    _numberController.text = '0';
    super.initState();
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void onUnitChanged(Unit newUnit) {
    setState(() {
      _unit = newUnit;
    });
  }

  List<Widget> convert({required String measure}) {
    final list = _converter.convert(value: _inputNumber, measure: measure);
    return List.generate(4, (index) {
      final int doubleIndex = index * 2;
      return Row(
        children: [
          Text(list[doubleIndex]),
          const SizedBox(width: 10),
          Text(list[doubleIndex + 1]),
        ],
      );
    });
  }
}
