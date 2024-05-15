import 'package:com_cipherschools_assignment/models/transaction.dart';
import 'package:com_cipherschools_assignment/providers/transaction_provider.dart';
import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:com_cipherschools_assignment/presentation/widgets/income_expense_item.dart';
import 'package:com_cipherschools_assignment/presentation/widgets/transaction_list_item.dart';
import 'package:com_cipherschools_assignment/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String currentMonth = '';

  @override
  void initState() {
    super.initState();
    final currentDate = DateTime.now();
    currentMonth = DateFormat.MMMM().format(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final transactions = ref.watch(transactionProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: light80,
        body: transactions.when(
          data: (data) {
            List<Transaction> monthTransactions =
                filterTransactionsByMonth(data, currentMonth, '2024');
            List<Transaction> incomeTransactions = monthTransactions
                .where((transaction) => transaction.transactionType == 'Income')
                .toList();
            List<Transaction> expenseTransactions = monthTransactions
                .where(
                    (transaction) => transaction.transactionType == 'Expense')
                .toList();
            double totalMonthIncome = incomeTransactions.fold(
                0, (sum, transaction) => sum + transaction.amount);
            double totalMonthExpense = expenseTransactions.fold(
                0, (sum, transaction) => sum + transaction.amount);
            double savings = totalMonthIncome - totalMonthExpense;
            List<Transaction> filteredTransactions =
                filterItemsByToday(data, 'Today');
            List<Transaction> todaysExpenseTransaction = filteredTransactions
                .where(
                    (transaction) => transaction.transactionType == 'Expense')
                .toList();
            double todaysExpense = todaysExpenseTransaction.fold(
                0, (sum, transaction) => sum + transaction.amount);
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
                                'https://images.unsplash.com/photo-1704212224803-42e34f022c36?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOHx8fGVufDB8fHx8fA%3D%3D',
                              ),
                            ),
                            Text(
                              currentMonth,
                              style: const TextStyle(
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
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Today\'s expense',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '\u{20B9}$todaysExpense',
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
                            title: 'Budget',
                            amount: totalMonthIncome.toString(),
                          ),
                          IncomeExpenseItem(
                            title: 'Balance',
                            amount: savings.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 9,
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
