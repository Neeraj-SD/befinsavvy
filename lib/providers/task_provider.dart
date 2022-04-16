import 'package:befinsavvy/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser;

  get tasks => <Task>[..._tasks];

  Future<void> fetchTasks() async {
    print('Fetching tasks...');
    final result = await FirebaseFirestore.instance
        .collectionGroup('tasks')
        // .doc(user!.uid)
        // .collection('tasks')
        // .doc('task_docs')
        // .collection('task_2022_4')
        .get();
    print('data: ${user!.uid}' + result.docs[0].data().toString());
  }

  Future<void> addTask(DateTime date, bool status) async {
    print('$date : $status task added.');
    final Task task = Task(date: date, status: status, id: '');
    _tasks.add(task);

    String userid = user!.uid;
    String year = date.year.toString();
    String month = date.month.toString();

    final ref = await collectionReference
        .doc(userid)
        .collection('tasks')
        .doc('task_${year}_$month')
        .collection('task_col')
        .add(task.toMap());
    print(await ref.get());
    await ref.update({'id': ref.id});
    print(await ref.get());
    notifyListeners();
  }
}
