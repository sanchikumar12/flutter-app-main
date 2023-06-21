import 'package:flutter/material.dart';

class FormHelper {
  static Widget buildTextField(String label, {controller,
    TextInputType? keyboardType, String? hintText}) {
    Widget? field = TextFormField(
      decoration: InputDecoration(
          labelText: label,
      ),
      controller: controller,
      keyboardType: keyboardType,
    );

    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: field,
    );
  }
}