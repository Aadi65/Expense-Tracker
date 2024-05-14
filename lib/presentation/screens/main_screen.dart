import 'package:com_cipherschools_assignment/presentation/screens/add_expense_screen.dart';
import 'package:com_cipherschools_assignment/presentation/screens/budget_screen.dart';
import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:com_cipherschools_assignment/presentation/screens/home_screen.dart';
import 'package:com_cipherschools_assignment/presentation/screens/transcation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final screens = [
    const HomeScreen(),
    const TransactionScreen(),
    const BudgetScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: light80,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            color: violet100,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            color: grey,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          elevation: 0.0,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                color: _selectedIndex == 0 ? violet100 : grey,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Transaction',
              icon: SvgPicture.asset(
                'assets/icons/transaction.svg',
                color: _selectedIndex == 1 ? violet100 : grey,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Budget',
              icon: SvgPicture.asset(
                'assets/icons/pie_chart.svg',
                color: _selectedIndex == 2 ? violet100 : grey,
              ),
            ),
          ],
          onTap: (index) => setState(() {
            _selectedIndex = index;
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: violet100,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddExpense(),
            ),
          );
        },
        elevation: 0.0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
