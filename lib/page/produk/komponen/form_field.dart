import 'package:flutter/material.dart';

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
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: label,
      ),
    );
  }
}
