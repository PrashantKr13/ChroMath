import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Color_Picker extends StatefulWidget {
  static Color btnColor = Colors.white24;
  final Function(Color) onColorChanged;
  Color_Picker({required this.onColorChanged});
  @override
  State<Color_Picker> createState() => _Color_PickerState();
}

class _Color_PickerState extends State<Color_Picker> {
  String key = "saved color";
  @override
  void initState() {
    super.initState();
    loadColor();
  }

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      pickerAreaHeightPercent: 0.5,
      pickerColor: (){
        return Color_Picker.btnColor;
      }(),
      onColorChanged: (Color color) {
        Color_Picker.btnColor = color;
        setState(() {
          setColor(color);
        }); //on the color picker
        widget.onColorChanged(Color_Picker.btnColor);
      },
    );
  }

  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? hexColor = prefs.getString(key);
    setState(() {
      String? hex = hexColor?.toUpperCase().replaceAll("#", "");
      if (hex?.length == 6) {
        hex = "FF" + hex!; // Add alpha channel if it's missing
      }
      Color_Picker.btnColor = hexColor != null
          ? Color(int.parse(hex!, radix: 16))
          : Colors.white24;
    });
  }

  void setColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, '#${color.value.toRadixString(16).padLeft(8, '0')}');
  }
}
