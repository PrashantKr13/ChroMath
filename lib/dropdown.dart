import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:calc_with_colors/calculator_screen.dart';

import 'color_picker.dart';

class DropDown extends StatefulWidget {
  static late Color selectedColor;
  final Function(Color) onColorChanged;
  DropDown({required this.onColorChanged});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String selectedValue = 'Option 1';
  bool isColorPickerVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PopupMenuButton(
            icon: Icon(Icons.colorize),
            offset: Offset(0,50),
            onSelected: (value) {},
            itemBuilder: (BuildContext) {
              return [
                PopupMenuItem(
                    value: 'toggle',
                    child: Color_Picker(
                      onColorChanged: (Color color) {
                        DropDown.selectedColor = color;
                        widget.onColorChanged(DropDown.selectedColor);
                      },
                    )
                )
              ];
            })
      ],
    );
  }
}
