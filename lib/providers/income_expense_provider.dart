import 'package:befinsavvy/models/amount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class IncomeExpenseProvider with ChangeNotifier {
  List<Amount> _expenses = [];
  List<Amount> _incomes = [];

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser;

  get expenses => _expenses;
  get incomes => _incomes;

  void fetchData() async {
    var result =
        await collectionReference.doc(user!.uid).collection('incomes').get();

    List<Amount> parsedList = [];
    result.docs.forEach((element) {
      parsedList.add(Amount(value: element['value']));
    });
    _incomes = parsedList;
    print(_incomes);

    result =
        await collectionReference.doc(user!.uid).collection('expenses').get();

    parsedList = [];
    result.docs.forEach((element) {
      parsedList.add(Amount(value: element['value']));
    });
    _expenses = parsedList;
    print(_expenses);
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
