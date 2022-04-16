import 'package:befinsavvy/providers/income_expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class IncomeExpenseScreen extends StatelessWidget {
  IncomeExpenseScreen({Key? key}) : super(key: key);

  final expenseController = TextEditingController();
  final incomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IncomeExpenseProvider>(context);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => provider.showExpenses(),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: provider.showExpensesState
                        ? Colors.purple
                        : Colors.grey,
                  ),
                  child: Text(
                    'Expenses',
                    style: TextStyle(
                      color: provider.showExpensesState
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => provider.showIncomes(),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: provider.showExpensesState
                        ? Colors.grey
                        : Colors.purple,
                  ),
                  child: Text(
                    'Incomes',
                    style: TextStyle(
                      color: provider.showExpensesState
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(18.0),
            child: PieChart(
              ringStrokeWidth: 36,
              chartRadius: MediaQuery.of(context).size.width / 1.5,
              dataMap: provider.displayDataMap.isNotEmpty
                  ? provider.displayDataMap
                  : {"0": 1},
              chartType: ChartType.ring,
              // showChartValuesOutside: true,
            ),
          ),
          ElevatedButton(
            onPressed: () => provider.prepareChart(),
            child: const Text('prepare chart'),
          ),
        ],
      ),
    ));
  }
}
