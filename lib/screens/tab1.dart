import 'package:befinsavvy/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class AddTaskModalSheet extends StatefulWidget {
  AddTaskModalSheet({Key? key}) : super(key: key) {
    // selectedDate = DateTime.now();
  }

  @override
  State<AddTaskModalSheet> createState() => _AddTaskModalSheetState();
}

class _AddTaskModalSheetState extends State<AddTaskModalSheet> {
  late DateTime? selectedDate;
  late bool status;

  @override
  void initState() {
    selectedDate = null;
    status = false;
    super.initState();
  }

  // void onAddTask(BuildContext context) {
  //   if (selectedDate == null) {
  //     return;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final provider = TaskProvider();
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
          Text(
            'Add a task',
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
                    : 'selectd date : ${DateFormat.yMMMd().format(selectedDate!)}',
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
                provider.addTask(selectedDate!, status);
              },
              child: const Text('ADD'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab1State extends State<Tab1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('ListView'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            context: context, builder: (_) => AddTaskModalSheet()),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
