import 'dart:ffi';

import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  String hint;
  IconData icon;
  TextEditingController controller;
  bool password;

  InputForm({
    required this.hint,
    required this.controller,
    required this.icon,
    this.password = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          obscureText: password,
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.amber,
                width: 2.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
