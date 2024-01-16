import 'package:com_cipherschools_assignment/models/transaction.dart';
import 'package:com_cipherschools_assignment/presentation/screens/transcation_screen.dart';
import 'package:com_cipherschools_assignment/providers/transaction_provider.dart';
import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:com_cipherschools_assignment/presentation/widgets/filter_item.dart';
import 'package:com_cipherschools_assignment/presentation/widgets/income_expense_item.dart';
import 'package:com_cipherschools_assignment/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void toggleFilter(String selectedCategory, String category) {
    if (selectedCategory == category) {
      ref.read(selectedFilterProvider.notifier).state = 'Today';
    } else {
      ref.read(selectedFilterProvider.notifier).state = category;
    }
  }

  @override
  void initState() {
    super.initState();
    ref.read(selectedFilterProvider.notifier).state = 'Today';
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
    final h = MediaQuery.of(context).size.height;
    final selectedFilter = ref.watch(selectedFilterProvider);
    final transactions = ref.watch(transactionProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: light80,
        body: transactions.when(
          data: (data) {
            List<Transaction> incomeTransactions = data
                .where((transaction) => transaction.transactionType == 'Income')
                .toList();
            double totalIncome = incomeTransactions.fold(
                0, (sum, transaction) => sum + transaction.amount);
            List<Transaction> expenseTransactions = data
                .where(
                    (transaction) => transaction.transactionType == 'Expense')
                .toList();
            double totalExpense = expenseTransactions.fold(
                0, (sum, transaction) => sum + transaction.amount);
            double balance = totalIncome - totalExpense;
            List<Transaction> filteredTransactions = data;
            if (selectedFilter.isNotEmpty) {
              filteredTransactions = filterItemsByTime(data, selectedFilter);
            }
            return Column(
              children: [
                Container(
                  height: h * 0.3741,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(32),
                      bottomEnd: Radius.circular(32),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 246, 229, 1),
                        Color.fromRGBO(248, 237, 216, 0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              foregroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1704212224803-42e34f022c36?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOHx8fGVufDB8fHx8fA%3D%3D'),
                            ),
                            const Text(
                              'October',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'assets/icons/notification.svg',
                                color: violet100,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01438,
                      ),
                      const Text(
                        'Account Balance',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: h * 0.01199),
                      Text(
                        '\u{20B9} $balance',
                        style: const TextStyle(
                          fontSize: 40,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: h * 0.03597),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IncomeExpenseItem(
                              title: 'Income', amount: totalIncome.toString()),
                          IncomeExpenseItem(
                            title: 'Expenses',
                            amount: totalExpense.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 9,
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
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text(
                        'Recent Transaction',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TransactionScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: violet20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                        ),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: violet100,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
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
