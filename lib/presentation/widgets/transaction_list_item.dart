import 'package:com_cipherschools_assignment/models/transaction.dart';
import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:com_cipherschools_assignment/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final time = DateFormat.jm().format(transaction.createdOn);
    return Container(
      height: h * 0.1067,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: getBackgroundColor(transaction.category),
            ),
            child: SvgPicture.asset(
              getIconString(transaction.category),
              color: getIconColor(transaction.category),
              width: 30,
              height: 30,
              fit: BoxFit.scaleDown,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  transaction.category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  transaction.description == null
                      ? ''
                      : transaction.description!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                transaction.transactionType == 'Income'
                    ? '+\u{20B9}${transaction.amount}'
                    : '-\u{20B9}${transaction.amount}',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: transaction.transactionType == 'Income'
                      ? green100
                      : red100,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
