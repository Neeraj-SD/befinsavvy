import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class AddTaskModalSheet extends StatelessWidget {
  AddTaskModalSheet({Key? key}) : super(key: key) {
    selectedDate = DateTime.now();
  }
  late DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    void datePicker() async {
      var datePicked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime.now());

      if (datePicked == null) return;
      // setState(() {
      //   selectedDate = datePicked;
      // });
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
                    : 'selectd date : ${DateFormat.yMMMd().format(selectedDate)}',
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.purple,
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          )
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
