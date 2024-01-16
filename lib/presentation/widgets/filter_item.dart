import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:flutter/material.dart';

class FilterItem extends StatelessWidget {
  final String title;
  final String selectedFilter;
  final VoidCallback onPressed;
  const FilterItem(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selectedFilter == title ? yellow20 : light80,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: selectedFilter == title ? yellow100 : light20,
          ),
        ),
      ),
    );
  }
}
