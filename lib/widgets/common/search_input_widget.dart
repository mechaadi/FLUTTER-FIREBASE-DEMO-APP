import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String label;
  const SearchInputWidget(
      {Key key, @required this.controller, @required this.onChanged,@required this.label})
      : assert(controller != null),
        assert(label != null),
        assert(onChanged != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 16.0, horizontal: 12.0),
      child: CupertinoTextField(
        onChanged: onChanged,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
        padding: EdgeInsets.all(16.0),
        prefix: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
          ),
          child: Icon(
            Icons.search,
            color: Colors.black54,
          ),
        ),
        controller: controller,
        placeholder: label,
        placeholderStyle: TextStyle(color: Colors.black54),
      ),
    );
  }
}
