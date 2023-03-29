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

  final TextStyle _normal =
      const TextStyle(fontSize: 17, fontWeight: FontWeight.normal);

  final TextStyle _medium =
      const TextStyle(fontSize: 17, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    double sizeX = MediaQuery.of(context).size.width;

    final SizedBox space =
        SizedBox(height: MediaQuery.of(context).size.height > 340 ? 24 : 12);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit converter'),
      ),
      body: Container(
        width: sizeX,
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  style: const TextStyle(fontSize: 24),
                  decoration: const InputDecoration(
                    labelText: 'Value',
                    labelStyle: TextStyle(fontSize: 17),
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
              space,
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: MenuAnchor(
                        builder: (context, controller, child) {
                          return FilledButton.tonal(
                            onPressed: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            child: Text(
                              _measures[_unit].toString(),
                              style: _medium,
                            ),
                          );
                        },
                        menuChildren:
                            List.generate(Unit.values.length, (index) {
                          final unit = Unit.values[index];
                          return MenuItemButton(
                            child: Text(
                              _measures[unit]!,
                              style: _medium,
                            ),
                            onPressed: () => onUnitChanged(unit),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'are',
                      style: _normal,
                    ),
                  ),
                ],
              ),
              space,
              ...answer(measure: _measures[_unit]!, space: space),
            ],
          ),
        ),
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

  List<Widget> answer({required String measure, required Widget space}) {
    final list = _converter.convert(value: _inputNumber, measure: measure);
    return List.generate(list.length - 1, (index) {
      if (index.isEven) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                child: Text(list[index], style: _normal),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Text(list[index + 1], style: _normal),
            ),
          ],
        );
      } else {
        return space;
      }
    });
  }
}
