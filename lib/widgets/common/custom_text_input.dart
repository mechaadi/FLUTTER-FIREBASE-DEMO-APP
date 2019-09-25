import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_input_label.dart';

class CustomTextInput extends StatefulWidget {
  final String label;
  final int minLines;
  final bool obsecure;
  final String initialValue;
  final String prefixText;
  final String suffixText;
  final Function(String) onSubmitted;
  final Function(bool) onFocused;
  final TextInputType inputType;
  final List<String> dropOptions;
  final String selectedDropOption;
  final Function(String) onDropSelected;
  final int maxLength;
  final List<TextInputFormatter>formatters;
  const CustomTextInput(
      {Key key,
      this.label,
      this.onFocused,
      this.minLines = 1,
      this.onSubmitted,
      this.inputType,
      this.obsecure = false,
      this.prefixText = "",
      this.suffixText,
      this.initialValue,
      this.dropOptions,
        this.maxLength=100,
      this.selectedDropOption, this.onDropSelected, this.formatters})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  FocusNode focusNode;
  TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue ?? "");
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (widget.onFocused != null) {
        widget.onFocused(focusNode.hasFocus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomInputLabel(
          label: widget.label,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autocorrect: true,
                  maxLength: widget.maxLength,
                  minLines: widget.minLines,
                  maxLines: widget.minLines,
                  enableInteractiveSelection: true,
                  onChanged: widget.onSubmitted,
                  obscureText: widget.obsecure,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: widget.inputType,
                  inputFormatters: widget.formatters,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 20.0),
                  decoration: InputDecoration(
                      prefixText: widget.prefixText,
                      suffixText: widget.suffixText,
                      suffixStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 20.0),
                      prefixStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 20.0),
                      counterStyle: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                          fontSize: 16.0),
                      border: UnderlineInputBorder(),
                      hasFloatingPlaceholder: false,
                      hintText: "Write here",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                          fontSize: 18.0)),
                ),
              ),
            ),
            SizedBox(
              width: 6.0,
            ),
            widget.dropOptions == null
                ? Container()
                : Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.6),
                      child: DropdownButtonFormField(
                        items: widget.dropOptions
                            .map((val) => DropdownMenuItem(
                                  child: Text(val,style: TextStyle(fontSize:20.0 ),),
                                  value: val,
                                ))
                            .toList(),
                         value: widget.selectedDropOption,
                       onChanged: widget.onDropSelected,
                      ),
                    ),

                  )
          ],
        )
      ],
    );
  }
}
