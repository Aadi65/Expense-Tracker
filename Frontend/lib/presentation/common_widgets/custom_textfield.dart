import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  const CustomTextfield({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool showPassword = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.hint == 'Password' ? !showPassword : false,
      keyboardType: widget.hint == 'Email' ? TextInputType.emailAddress : null,
      autocorrect: false,
      textCapitalization: widget.hint == 'Name'
          ? TextCapitalization.words
          : TextCapitalization.none,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: light60, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: light60, width: 1.0),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(
                  !showPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              )
            : null,
        hintText: widget.hint,
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
