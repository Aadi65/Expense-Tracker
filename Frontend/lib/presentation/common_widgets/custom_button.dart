import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final void Function() function;
  final Widget? widget;
  const CustomButton(
      {super.key, required this.title, required this.function, this.widget});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: TextButton(
        onPressed: function,
        style: TextButton.styleFrom(
          backgroundColor: violet100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: widget == null
            ? Text(
                title,
                style: const TextStyle(
                  inherit: true,
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              )
            : widget!,
      ),
    );
  }
}
