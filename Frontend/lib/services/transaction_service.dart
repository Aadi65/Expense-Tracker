import 'package:com_cipherschools_assignment/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final transactionSerivceProvider =
    Provider<TransactionService>((ref) => TransactionService());

class TransactionService {
  late Box<Transaction> _box;
  late List<Transaction> _transactions;

  Future<List<Transaction>> getTransactions() async {
    _box = Hive.box<Transaction>('transactions');
    _transactions = _box.values.toList();
    return _transactions;
  }

  Future<List<Transaction>> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
    return _box.values.toList();
  }

  Future<List<Transaction>> removeTransaction(String id) async {
    await _box.delete(id);
    return _box.values.toList();
  }

  Future<void> deleteAll() async {
    _box.clear();
  }
}
