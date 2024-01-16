import 'package:com_cipherschools_assignment/models/transaction.dart';
import 'package:com_cipherschools_assignment/services/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionProvider =
    AsyncNotifierProvider<TransactionNotifier, List<Transaction>>(
  () => TransactionNotifier(),
);

class TransactionNotifier extends AsyncNotifier<List<Transaction>> {
  TransactionService get _transactionService =>
      ref.read(transactionSerivceProvider);

  @override
  Future<List<Transaction>> build() => getCart();

  Future<void> addTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _transactionService.addTransaction(transaction);
    });
  }

  Future<void> deleteTransaction(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      List<Transaction> cart = await _transactionService.removeTransaction(id);
      return cart;
    });
  }

  Future<List<Transaction>> getCart() async {
    return await _transactionService.getTransactions();
  }

  Future<void> deleteAll() async {
    return await _transactionService.deleteAll();
  }
}

final selectedFilterProvider = StateProvider<String>((ref) => 'Today');
