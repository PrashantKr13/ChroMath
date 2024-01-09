import 'package:flutter/material.dart';
import 'package:calc_with_colors/button_values.dart';
import 'package:calc_with_colors/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalculatorScreenState();
  }
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  Color changedColor = Colors.white24;

  @override
  void initState() {
    super.initState();
    loadColor();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          //colorPicker
          DropDown(
            onColorChanged: (Color color) {
              setState(() {
                changedColor = color;
              });
            },
          ),
          //output
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$number1$operand$number2".isEmpty
                      ? "0"
                      : "$number1$operand$number2",
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
          //buttons
          Wrap(
            children: Btn.buttonValues
                .map((value) => SizedBox(
                    width: value == Btn.n0
                        ? screenSize.width / 2
                        : screenSize.width / 4,
                    height: screenSize.width / 5,
                    child: buildButton(value)))
                .toList(),
          )
        ]),
      ),
    );
  }

  Widget buildButton(value) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Material(
          clipBehavior: Clip.hardEdge,
          shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
              borderRadius: BorderRadius.circular(50)),
          color: getBtnColor(value),
          child: InkWell(
              onTap: () => onBtnTap(value),
              child: Center(
                  child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )))),
    );
  }

  //###########

  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? hexColor = prefs.getString('saved color');
    String? hex = hexColor?.toUpperCase().replaceAll("#", "");
    if (hex?.length == 6) {
      hex = "FF" + hex!; // Add alpha channel if it's missing
    }
    setState(() {
      changedColor = Color(int.parse(hex!, radix: 16));
    });
  }

  //###########

  Color getBtnColor(value) {
    return [Btn.clr, Btn.del].contains(value)
        ? Colors.blueGrey
        : [
            Btn.add,
            Btn.per,
            Btn.multiply,
            Btn.divide,
            Btn.subtract,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : changedColor;
  }

  //###########

  void onBtnTap(value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      setState(() {
        number1 = "";
        operand = "";
        number2 = "";
      });
      return;
    }
    if (value == Btn.per) {
      convertToPercentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }
  //##########

  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;
    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);
    double result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      number1 = "$result";
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

  //##########

  void convertToPercentage() {
    if (number1.isNotEmpty && number2.isNotEmpty && operand.isNotEmpty) {
      if (operand == Btn.divide) {
        calculate();
        final number = double.parse(number1);
        number1 = "${number * 100}";
      } else {
        calculate();
        final number = double.parse(number1);
        number1 = "${number / 100}";
      }
    } else if (number1.isNotEmpty && number2.isEmpty && operand.isEmpty) {
      final number = double.parse(number1);
      number1 = "${number / 100}";
    }
    if (operand.isNotEmpty) {
      return;
    }
    setState(() {
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

  //##########

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  //###########

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.dot && (number1.isEmpty || number1 == "0")) {
        number1 = "0.";
      } else {
        number1 += value;
      }
    } else if (operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.dot && (number2.isEmpty || number2 == "0")) {
        number2 = "0.";
      } else {
        number2 += value;
      }
    }
    setState(() {});
  }
}
