import 'package:flutter/material.dart';

import 'package:pos_app/constant.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.controller,
    required this.validator,
    required this.label,
  }) : super(key: key);

  final TextEditingController controller;
  final String validator;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => (value == null || value.isEmpty) ? validator : null,
      controller: controller,
      cursorColor: primaryColor,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: primaryColor),
          ),
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14, color: textColor),
          focusColor: primaryColor,
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: textColor))),
    );
  }
}
