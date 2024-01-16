import 'package:com_cipherschools_assignment/models/transaction.dart';
import 'package:com_cipherschools_assignment/presentation/widgets/filter_item.dart';
import 'package:com_cipherschools_assignment/presentation/widgets/transaction_list_item.dart';
import 'package:com_cipherschools_assignment/providers/transaction_provider.dart';
import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  List<Transaction> filteredTransactions = [];
  void toggleFilter(String selectedCategory, String category) {
    if (selectedCategory == category) {
      ref.read(selectedFilterProvider.notifier).state = '';
    } else {
      ref.read(selectedFilterProvider.notifier).state = category;
    }
  }

  List<Transaction> filterItemsByTime(
      List<Transaction> items, String duration) {
    DateTime now = DateTime.now();

    return items.where((item) {
      DateTime itemDate = item.createdOn;
      switch (duration) {
        case 'Today':
          return itemDate.isAfter(now.subtract(const Duration(days: 1))) &&
              itemDate.isBefore(now.add(const Duration(days: 1)));
        case 'Week':
          return itemDate.isAfter(now.subtract(const Duration(days: 7))) &&
              itemDate.isBefore(now.add(const Duration(days: 1)));
        case 'Month':
          return itemDate.isAfter(now.subtract(const Duration(days: 30))) &&
              itemDate.isBefore(now.add(const Duration(days: 1)));
        case 'Year':
          return itemDate.isAfter(now.subtract(const Duration(days: 365))) &&
              itemDate.isBefore(now.add(const Duration(days: 1)));
        default:
          return itemDate == itemDate;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedFilter = ref.watch(selectedFilterProvider);
    final transactions = ref.watch(transactionProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
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
            List<Transaction> filteredTransactions = data;
            if (selectedFilter.isNotEmpty) {
              filteredTransactions = filterItemsByTime(data, selectedFilter);
            }
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilterItem(
                      title: 'Today',
                      onPressed: () {
                        toggleFilter(selectedFilter, 'Today');
                      },
                      selectedFilter: selectedFilter,
                    ),
                    FilterItem(
                      title: 'Week',
                      onPressed: () {
                        toggleFilter(selectedFilter, 'Week');
                      },
                      selectedFilter: selectedFilter,
                    ),
                    FilterItem(
                      title: 'Month',
                      onPressed: () {
                        toggleFilter(selectedFilter, 'Month');
                      },
                      selectedFilter: selectedFilter,
                    ),
                    FilterItem(
                      title: 'Year',
                      onPressed: () {
                        toggleFilter(selectedFilter, 'Year');
                      },
                      selectedFilter: selectedFilter,
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
                            return TransactionListItem(
                              transaction: filteredTransactions[index],
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
