import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Color getBackgroundColor(String category) {
  switch (category) {
    case 'Travel':
      return blue20;
    case 'Food':
      return red20;
    case 'Shopping':
      return yellow20;
    case 'Subscription':
      return violet20;
    case 'House':
      return green20;
    default:
      return Colors.lightGreen;
  }
}

Color getIconColor(String category) {
  switch (category) {
    case 'Travel':
      return blue100;
    case 'Food':
      return red100;
    case 'Shopping':
      return yellow100;
    case 'Subscription':
      return violet100;
    case 'House':
      return green100;
    default:
      return Colors.green;
  }
}

String getIconString(String category) {
  switch (category) {
    case 'Travel':
      return 'assets/icons/car.svg';
    case 'Food':
      return 'assets/icons/restaurant.svg';
    case 'Shopping':
      return 'assets/icons/shopping_bag.svg';
    case 'Subscription':
      return 'assets/icons/recurring_bill.svg';
    case 'House':
      return 'assets/icons/home.svg';
    default:
      return 'wallet_3';
  }
}
