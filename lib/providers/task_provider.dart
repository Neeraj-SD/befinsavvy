import 'package:befinsavvy/models/task.dart';
import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  get task => _tasks;

  void fetchTasks() {}

  void addTask(DateTime date, bool status) {
    print('$date : $status task added.');
    final Task task = Task(date: date, status: status, id: '');
    _tasks.add(task);
    notifyListeners();
  }
}
