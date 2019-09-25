import 'package:flutter/material.dart';

class CustomDropDownWidget extends StatelessWidget {
  final List<String> items;
  final String label;
  final String value;
  final Function(String) onValueSelected;

  const CustomDropDownWidget({Key key,@required this.items,@required this.label,@required this.onValueSelected, this.value}) : super(key: key);

  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: items
          .map((val) => DropdownMenuItem(
                child: Text(
                  "$val",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 20.0),
                ),
                value: val,
              ))
          .toList(),
      onChanged: onValueSelected,
      value: value,
      decoration: InputDecoration(
          suffixStyle: TextStyle(
              fontWeight: FontWeight.w300, color: Colors.black, fontSize: 20.0),
          prefixStyle: TextStyle(
              fontWeight: FontWeight.w300, color: Colors.black, fontSize: 20.0),
          counterStyle: TextStyle(
              fontWeight: FontWeight.w200, color: Colors.black, fontSize: 16.0),
          border: UnderlineInputBorder(),
          hasFloatingPlaceholder: true,
          labelText: label,
      ),
    );
  }
}
