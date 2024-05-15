import 'package:com_cipherschools_assignment/models/transaction.dart';
import 'package:com_cipherschools_assignment/providers/transaction_provider.dart';
import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:com_cipherschools_assignment/presentation/common_widgets/custom_button.dart';
import 'package:com_cipherschools_assignment/presentation/common_widgets/custom_textfield.dart';
import 'package:com_cipherschools_assignment/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddExpense extends ConsumerStatefulWidget {
  const AddExpense({super.key});

  @override
  ConsumerState<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends ConsumerState<AddExpense> {
  String transactionType = 'Expense';
  String? category;
  Mode? mode;
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: violet100,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: violet100,
        centerTitle: true,
        title: DropdownButtonHideUnderline(
          child: DropdownButton(
            icon: SvgPicture.asset(
              'assets/icons/arrow_down_2.svg',
              color: Colors.white,
            ),
            value: transactionType,
            selectedItemBuilder: (BuildContext context) {
              return [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Expense',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Income',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ];
            },
            items: const [
              DropdownMenuItem(
                value: 'Expense',
                child: Text(
                  'Expense',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Income',
                child: Text(
                  'Income',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
            onChanged: (value) => setState(() => transactionType = value!),
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      color: violet100,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: Text(
                      'How much?',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: light80),
                    ),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                    maxLength: 10,
                    decoration: InputDecoration(
                      counter: Container(),
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(
                          right: 10,
                          left: 24,
                        ),
                        child: Text(
                          '\u{20B9}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 64,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    maxLines: 1,
                  ),
                  Container(
                    width: double.infinity,
                    height: h / 2,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: light60, width: 1.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              icon: SvgPicture.asset(
                                'assets/icons/arrow_down_2.svg',
                                color: light20,
                              ),
                              hint: const Text(
                                'Category',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  color: textColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              value: category,
                              style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  color: Colors.black),
                              items: transactionType == 'Income'
                                  ? incomeCategory.map(buildMenuItem).toList()
                                  : expenseCategory.map(buildMenuItem).toList(),
                              onChanged: (value) =>
                                  setState(() => category = value!),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomTextfield(
                          hint: 'Description',
                          controller: descriptionController,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: light60, width: 1.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              icon: SvgPicture.asset(
                                'assets/icons/arrow_down_2.svg',
                                color: light20,
                              ),
                              hint: const Text(
                                'Wallet',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  color: textColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              value: mode,
                              items: Mode.values.map((Mode mode) {
                                return DropdownMenuItem<Mode>(
                                  value: mode,
                                  child: Text(
                                    mode.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (Mode? newvalue) {
                                setState(() {
                                  mode = newvalue!;
                                });
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        CustomButton(
                          title: 'Continue',
                          function: () async {
                            if (amountController.text.isEmpty) {
                              showSnackBar(context, 'Please enter amount');
                              return;
                            }
                            if (category == null) {
                              showSnackBar(context, 'Please select a category');
                              return;
                            }
                            if (mode == null) {
                              showSnackBar(
                                  context, "Please select transaction mode");
                              return;
                            }
                            Transaction transaction = Transaction(
                              amount: double.parse(amountController.text),
                              transactionType: transactionType,
                              category: category!,
                              mode: mode!,
                              description: descriptionController.text.isEmpty
                                  ? null
                                  : descriptionController.text,
                            );
                            await ref
                                .read(transactionProvider.notifier)
                                .addTransaction(transaction);
                            if (context.mounted) {
                              showSnackBar(context,
                                  "Added a new ${transactionType.toLowerCase()}");
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(),
        ),
      );
}
