import 'package:com_cipherschools_assignment/models/transaction.dart';
import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

int monthFromString(String monthString) {
  switch (monthString.toLowerCase()) {
    case 'january':
      return 1;
    case 'february':
      return 2;
    case 'march':
      return 3;
    case 'april':
      return 4;
    case 'may':
      return 5;
    case 'june':
      return 6;
    case 'july':
      return 7;
    case 'august':
      return 8;
    case 'september':
      return 9;
    case 'october':
      return 10;
    case 'november':
      return 11;
    case 'december':
      return 12;
    default:
      throw ArgumentError('Invalid month string: $monthString');
  }
}

DateTime startOfMonth(String monthString, int year) {
  int month = monthFromString(monthString);
  return DateTime(year, month);
}

DateTime endOfMonth(String monthString, int year) {
  int month = monthFromString(monthString);
  return DateTime(year, month + 1).subtract(const Duration(days: 1));
}

List<Transaction> filterTransactionsByMonth(
    List<Transaction> transactions, String monthString, String year) {
  int intYear = int.parse(year);
  DateTime start = startOfMonth(monthString, intYear);
  DateTime end = endOfMonth(monthString, intYear);
  return transactions.where((transaction) {
    DateTime transactionDate = transaction.createdOn;
    // Check if the transaction date is within the selected month
    return transactionDate.isAfter(start) && transactionDate.isBefore(end);
  }).toList();
}

List<Transaction> filterItemsByToday(List<Transaction> items, String duration) {
  DateTime now = DateTime.now();

  return items.where((item) {
    DateTime itemDate = item.createdOn;
    return itemDate.isAfter(now.subtract(const Duration(days: 1))) &&
        itemDate.isBefore(now.add(const Duration(days: 1)));
  }).toList();
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
      return Colors.lightGreenAccent;
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
      return 'assets/icons/wallet_3.svg';
  }
}
