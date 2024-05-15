import 'package:com_cipherschools_assignment/models/transaction.dart';
import 'package:com_cipherschools_assignment/presentation/widgets/custom_dropdown.dart';
import 'package:com_cipherschools_assignment/presentation/widgets/transaction_list_item.dart';
import 'package:com_cipherschools_assignment/providers/transaction_provider.dart';
import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:com_cipherschools_assignment/utils/functions.dart';
import 'package:com_cipherschools_assignment/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  int currentYear = 0;
  int currentMonth = 0;
  final List<String> years = [];
  late String _selectedMonth;
  late String _selectedYear;

  @override
  void initState() {
    super.initState();
    final currentDate = DateTime.now();
    currentMonth = currentDate.month;
    currentYear = currentDate.year;
    _selectedMonth = DateFormat.MMMM().format(currentDate);
    _selectedYear = DateFormat.y().format(currentDate);
    for (int i = currentYear - 10; i <= currentYear; i++) {
      years.add(i.toString());
    }
  }

  List<Transaction> filteredTransactions = [];

  void onMonthChange(String? value) {
    setState(() {
      _selectedMonth = value!;
    });
  }

  void onYearChange(String? value) {
    setState(() {
      _selectedYear = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          elevation: 0.0,
          backgroundColor: light80,
          centerTitle: true,
          title: const Text(
            'Transactions',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: transactions.when(
          data: (data) {
            List<Transaction> filteredTransactions = [];

            filteredTransactions =
                filterTransactionsByMonth(data, _selectedMonth, _selectedYear);

            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomDropDown(
                      selectedMonth: _selectedMonth,
                      onChanged: onMonthChange,
                      items: months,
                      width: 120,
                    ),
                    CustomDropDown(
                      selectedMonth: _selectedYear,
                      onChanged: onYearChange,
                      items: years,
                      width: 96,
                    ),
                  ],
                ),
                Expanded(
                  child: filteredTransactions.isEmpty
                      ? const Center(
                          child: Text('No transactions'),
                        )
                      : ListView.builder(
                          itemBuilder: (builder, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                ref
                                    .read(transactionProvider.notifier)
                                    .deleteTransaction(
                                        filteredTransactions[index].id);
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        const Text('Removed from favourites'),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () {
                                        ref
                                            .read(transactionProvider.notifier)
                                            .addTransaction(
                                                filteredTransactions[index]);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: TransactionListItem(
                                transaction: filteredTransactions[index],
                              ),
                            );
                          },
                          itemCount: filteredTransactions.length,
                        ),
                ),
              ],
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
