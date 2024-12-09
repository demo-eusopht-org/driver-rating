import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginPasswordField extends StatefulWidget {
  TextEditingController? controller;

  String? hintText;
  int? maxLines;
  IconData? icon;
  LoginPasswordField({
    super.key,
    this.controller,
    this.hintText,
    this.maxLines,
    this.icon,
  });

  @override
  State<LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<LoginPasswordField> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: ((val) => widget.controller!.text.isEmpty
          ? "Please Enter ${widget.hintText}"
          : null),
      onChanged: (value) {
        setState(() {
          value = widget.controller!.text;
        });
      },
      controller: widget.controller,
      obscureText: hidePassword,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          size: 18,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            hidePassword ? Icons.visibility : Icons.visibility_off,
            size: 18,
          ),
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
        ),
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
