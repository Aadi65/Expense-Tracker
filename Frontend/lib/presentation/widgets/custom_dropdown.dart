import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  final String selectedMonth;
  final Function(String? value) onChanged;
  final List<String> items;
  final double width;
  const CustomDropDown({
    super.key,
    required this.selectedMonth,
    required this.onChanged,
    required this.items,
    required this.width,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
      customButton: Container(
        height: 30,
        width: widget.width,
        decoration: BoxDecoration(
            color: light80,
            borderRadius: BorderRadius.circular(
              20,
            ),
            border: Border.all(color: Colors.black)),
        child: Row(
          children: [
            const Spacer(),
            Center(
              child: Text(
                widget.selectedMonth,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
      onChanged: (value) => widget.onChanged.call(value),
      value: widget.selectedMonth,
      alignment: Alignment.centerRight,
      dropdownStyleData: DropdownStyleData(
        elevation: 0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20,
          ),
          color: Colors.white,
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        selectedMenuItemBuilder: (context, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.selectedMonth,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
      underline: const SizedBox(),
      items: List.generate(
        widget.items.length,
        (index) => DropdownMenuItem(
          alignment: Alignment.center,
          value: widget.items[index],
          child: Text(
            widget.items[index],
          ),
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
