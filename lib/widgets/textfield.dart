import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final ontap;
  final textFieldontap;

  bool isIcon;
  IconData? icon;
  IconData? icon1;

  CustomTextField(
      {super.key,
      required this.isIcon,
      required this.controller,
      required this.hintText,
      required this.maxLines,
      this.ontap,
      this.textFieldontap,
      this.icon,
      this.icon1});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: ((val) => widget.controller.text.isEmpty
          ? "Please Enter ${widget.hintText}"
          : null),
      onChanged: (value) {
        setState(() {
          value = widget.controller.text;
        });
      },
      onTap: widget.textFieldontap,
      controller: widget.controller,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        prefixIcon: widget.isIcon == true
            ? GestureDetector(
                onTap: widget.ontap,
                child: Icon(
                  widget.icon,
                  size: 18,
                ),
              )
            : null,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
