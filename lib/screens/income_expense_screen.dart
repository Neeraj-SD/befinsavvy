import 'package:befinsavvy/providers/income_expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeExpenseScreen extends StatelessWidget {
  IncomeExpenseScreen({Key? key}) : super(key: key);

  final expenseController = TextEditingController();
  final incomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IncomeExpenseProvider>(context);
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(labelText: 'Income'),
            controller: incomeController,
            keyboardType: TextInputType.number,
            // onSubmitted: (_) => submitData(),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (incomeController.value.text.isEmpty) return;

            double amount = double.parse(incomeController.value.text.trim());
            provider.addIncome(amount);
            incomeController.clear();
          },
          child: const Text('Add income'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(labelText: 'Expense'),
            controller: expenseController,
            keyboardType: TextInputType.number,
            // onSubmitted: (_) => submitData(),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (expenseController.value.text.isEmpty) return;

            double amount = double.parse(expenseController.value.text.trim());
            provider.addExpense(amount);
            expenseController.clear();
          },
          child: const Text('Add expense'),
        ),
        ElevatedButton(
          onPressed: () => provider.fetchData(),
          child: const Text('Fetch data'),
        ),
      ],
    ));
  }
}
