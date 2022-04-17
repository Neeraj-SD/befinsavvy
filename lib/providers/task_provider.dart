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
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .get();

    List<Task> response_tasks = [];
    result.docs.forEach((element) async {
      final list = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('tasks')
          .doc(element.id)
          .collection('task')
          .get();
      // print(list.docs);
      response_tasks = [...response_tasks, ...taskFromJson(list.docs)];
      _tasks = response_tasks;
      print(response_tasks);
      orderByDate();
      notifyListeners();
    });
  }

  void orderByDate() {
    _tasks.sort(((a, b) => a.date.compareTo(b.date)));
  }

  Future<void> deleteTask(Task task) async {
    final response = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .doc('task_${task.date.year}_${task.date.month}')
        .collection('task')
        .doc(task.id)
        .delete();
    fetchTasks();
  }

  Future<void> addTask(DateTime date, bool status) async {
    print('$date : $status task added.');
    final Task task = Task(date: date, status: status, id: '');
    // _tasks.add(task);

    String userid = user!.uid;
    String year = date.year.toString();
    String month = date.month.toString();

    await collectionReference.doc(user!.uid).set({'user_id': user!.uid});
    await collectionReference
        .doc(user!.uid)
        .collection('tasks')
        // .collection('tasks')
        .doc('task_${year}_$month')
        .set({'year_month': '${year}_$month'});

    final ref = await collectionReference
        .doc(user!.uid)
        .collection('tasks')
        // .collection('tasks')
        .doc('task_${year}_$month')
        .collection('task')
        .add(task.toMap());

    // .add(task.toMap());
    // print(await ref.get());
    await ref.update({'id': ref.id});
    fetchTasks();
  }

  Future<void> updateTask(Task task, DateTime selectedDate, bool status) async {
    final updated = Task(id: task.id, date: selectedDate, status: status);

    if (updated.date.month != task.date.month ||
        updated.date.year != task.date.year) {
      deleteTask(task);
      addTask(updated.date, updated.status);
      return;
    }

    final response = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .doc('task_${task.date.year}_${task.date.month}')
        .collection('task')
        .doc(task.id)
        .update(updated.toMap());

    fetchTasks();
  }
}
