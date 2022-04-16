import 'package:befinsavvy/models/amount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class IncomeExpenseProvider with ChangeNotifier {
  List<Amount> _expenses = [];
  List<Amount> _incomes = [];

  bool showExpensesState = true;

  Map<String, double> expenseDataMap = {};
  Map<String, double> incomeDataMap = {};
  Map<String, double> displayDataMap = {};

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser;

  get expenses => _expenses;
  get incomes => _incomes;

  void showExpenses() {
    showExpensesState = true;
    displayDataMap = expenseDataMap;
    notifyListeners();
  }

  void showIncomes() {
    showExpensesState = false;
    displayDataMap = incomeDataMap;
    notifyListeners();
  }

  void fetchData() async {
    var result =
        await collectionReference.doc(user!.uid).collection('incomes').get();

    List<Amount> parsedList = [];
    result.docs.forEach((element) {
      parsedList.add(Amount(value: element['value']));
    });
    _incomes = parsedList;
    print('incomes $_incomes');

    result =
        await collectionReference.doc(user!.uid).collection('expenses').get();

    parsedList = [];
    result.docs.forEach((element) {
      parsedList.add(Amount(value: element['value']));
    });
    _expenses = parsedList;
    print('expenses $_expenses');
  }

  void prepareChart() {
    Map<String, double> map = {};
    // _expenses.forEach((e) => ma.add(e.value));

    for (int i = 0; i < _expenses.length; i++) {
      map['$i'] = _expenses[i].value;
    }

    expenseDataMap = map;

    map = {};
    for (int i = 0; i < _incomes.length; i++) {
      map['$i'] = _incomes[i].value;
    }

    incomeDataMap = map;

    notifyListeners();
    // print(_expenses.asMap());
  }

  Future<void> addIncome(double amt) async {
    final amount = Amount(value: amt);

    await collectionReference
        .doc(user!.uid)
        .collection('incomes')
        .add(amount.toMap());
    fetchData();
  }

  Future<void> addExpense(double amt) async {
    final amount = Amount(value: amt);

    await collectionReference
        .doc(user!.uid)
        .collection('expenses')
        .add(amount.toMap());
    fetchData();
  }
}
