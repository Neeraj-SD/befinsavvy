import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:befinsavvy/providers/task_provider.dart';

import '../constants/enums.dart';
import '../models/task.dart';

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class AddTaskModalSheet extends StatefulWidget {
  AddTaskModalSheet({
    Key? key,
    this.selectedTask,
  }) : super(key: key);
  Task? selectedTask;

  @override
  State<AddTaskModalSheet> createState() => _AddTaskModalSheetState();
}

class _AddTaskModalSheetState extends State<AddTaskModalSheet> {
  late DateTime? selectedDate;
  late bool status;

  @override
  void initState() {
    status = false;

    widget.selectedTask != null
        ? selectedDate = widget.selectedTask!.date
        : selectedDate = null;

    widget.selectedTask != null
        ? status = widget.selectedTask!.status
        : status = false;
    super.initState();
  }

  // void onAddTask(BuildContext context) {
  //   if (selectedDate == null) {
  //     return;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    void datePicker() async {
      var datePicked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime.now());

      if (datePicked == null) return;
      setState(() {
        selectedDate = datePicked;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.selectedTask == null
              ? Text(
                  'Add a task',
                  style: Theme.of(context).textTheme.headline6,
                )
              : Text(
                  'Update task',
                  style: Theme.of(context).textTheme.headline6,
                ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate == null
                    ? 'No date selected'
                    : 'selected date : ${DateFormat.yMMMd().format(selectedDate!)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              FlatButton(
                onPressed: datePicker,
                child: Text(
                  'Choose Date',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Status: ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    status = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: status ? Colors.purple : Colors.grey,
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: status ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    status = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: status ? Colors.grey : Colors.purple,
                  ),
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: status ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              onPressed: () {
                if (selectedDate == null) return;

                if (widget.selectedTask != null &&
                    widget.selectedTask!.status == status &&
                    widget.selectedTask!.date == selectedDate) {
                  return;
                }

                if (widget.selectedTask == null) {
                  provider.addTask(selectedDate!, status);
                } else {
                  provider.updateTask(
                      widget.selectedTask!, selectedDate!, status);
                }
              },
              child: Text(widget.selectedTask != null ? 'UPDATE' : 'ADD'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab1State extends State<Tab1> {
  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    // print(context.read<TaskProvider>().tasks);
    final provider = Provider.of<TaskProvider>(context);

    if (isInit) {
      provider.fetchTasks();
      isInit = false;
    }
    // final provider = TaskProvider();
    return Scaffold(
      appBar: AppBar(title: const Text('BeFinSavvy'), actions: [
        PopupMenuButton(
          onSelected: ((FilteredValue value) => provider.setFilter(value)),
          icon: const Icon(Icons.more_vert),
          itemBuilder: (_) => [
            const PopupMenuItem(
              child: Text('Completed only'),
              value: FilteredValue.Completed,
            ),
            const PopupMenuItem(
              child: Text('UnCompleted only'),
              value: FilteredValue.Uncompleted,
            ),
            const PopupMenuItem(
              child: Text('Show All'),
              value: FilteredValue.All,
            ),
          ],
        ),
      ]),
      body: provider.displayList.isEmpty
          ? const Center(
              child: Text('No Tasks'),
            )
          : ListView.builder(
              itemCount: provider.displayList.length,
              itemBuilder: (_, index) => ExpansionTile(
                leading: provider.displayList[index].status
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                title: Text('${provider.displayList[index].id}'),
                subtitle: Text('${provider.displayList[index].date}'),
                // trailing: Text('${provider.displayList[index].status}'),
                // trailing: IconButton(
                //   icon: const Icon(Icons.more_vert),
                //   onPressed: () {},
                // ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () =>
                            provider.deleteTask(provider.displayList[index]),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => ListenableProvider.value(
                            value: provider,
                            child: AddTaskModalSheet(
                              selectedTask: provider.displayList[index],
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.edit,
                          // color: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (_) => ListenableProvider.value(
            value: provider,
            child: AddTaskModalSheet(),
          ),
        ),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
