import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IncomeExpenseItem extends StatelessWidget {
  final String title;
  final String amount;
  const IncomeExpenseItem(
      {super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      width: w * 0.4533,
      height: h * 0.09692,
      decoration: BoxDecoration(
        color: title == 'Budget' ? green100 : red100,
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: h * 0.02093,
      ),
      child: Row(
        children: [
          Container(
            width: w * 0.128,
            height: h * 0.0575,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: light80,
            ),
            child: SvgPicture.asset(
              title == 'Income'
                  ? 'assets/icons/income.svg'
                  : 'assets/icons/expense.svg',
              color: title == 'Balance' ? green100 : red100,
              width: 24,
              height: h * 0.03448,
              fit: BoxFit.scaleDown,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: light20,
                ),
              ),
              Text(
                '\u{20B9}$amount',
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: light20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
