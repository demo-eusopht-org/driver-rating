import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class PasswordField extends StatefulWidget {
  TextEditingController? controller;
  TextEditingController? confirmController;
  String? hintText;
  int? maxLines;
  IconData? icon;
  PasswordField(
      {super.key,
      this.controller,
      this.hintText,
      this.maxLines,
      this.confirmController,
      this.icon});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

bool hidePassword = true;

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: ((val) => widget.controller!.text.isEmpty
          ? "Please Enter ${widget.hintText}"
          : widget.controller!.text != widget.confirmController!.text
              ? "Password does not match"
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
