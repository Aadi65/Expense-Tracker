import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
class Transaction {
  @HiveField(0)
  String id;
  @HiveField(1)
  String? description;
  @HiveField(2)
  double amount;
  @HiveField(3)
  String transactionType;
  @HiveField(4)
  String category;
  @HiveField(5)
  DateTime createdOn;
  @HiveField(6)
  Mode mode;

  Transaction({
    String? id,
    DateTime? createdOn,
    this.description,
    required this.amount,
    required this.transactionType,
    required this.category,
    required this.mode,
  })  : id = id ?? const Uuid().v4(),
        createdOn = createdOn ?? DateTime.now();
}

const modeString = <Mode, String>{
  Mode.card: 'Card',
  Mode.cash: 'Cash',
};

List<String> expenseCategory = [
  'Travel',
  'Food',
  'Shopping',
  'Subscription',
  'Household',
];
List<String> incomeCategory = ['Deposits', 'Savings', 'Salary'];

@HiveType(typeId: 2)
enum Mode {
  @HiveField(0)
  cash,
  @HiveField(1)
  card,
}
