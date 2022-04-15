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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedDate == null
                ? 'No date selected'
                : 'selectd date : ${DateFormat.yMMMd().format(selectedDate)}'),
            FlatButton(
              onPressed: datePicker,
              child: Text(
                'Choose Date',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ],
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
