import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInputWidget extends StatelessWidget {
  final String label;
  final String initialValue;
  final Function(String) onChanged;
  final bool isObscureText;
  final List<TextInputFormatter> inputFormatters;
  final bool readOnly;
  final int maxLength;
  final int minLines;
  const CustomTextInputWidget(
      {Key key,
      @required this.label,
      @required this.onChanged,
      this.isObscureText=false, this.inputFormatters, this.initialValue, this.readOnly=false, this.maxLength=100, this.minLines=1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: minLines,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
      controller: readOnly?TextEditingController(text: initialValue):null,
      onChanged: onChanged,
      obscureText: isObscureText,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff8D8D8D))),
          labelText: label,
          hasFloatingPlaceholder: true,
          labelStyle: TextStyle(fontSize: 16, color: Color(0xff8D8D8D))),
    );
  }
}
