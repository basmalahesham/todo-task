import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo_task/core/network/firestore_utils.dart';
import 'package:todo_task/views/widgets/task_item_widget.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 40, left: 20),
          width: mediaQuery.width,
          height: mediaQuery.height * 0.15,
          color: Colors.deepPurple,
          child: Text(
            'To Do List',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        CalendarTimeline(
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onDateSelected: (date) {
            selectedDate = date;
            setState(() {});
          },
          leftMargin: 20,
          monthColor: Colors.black,
          dayColor: Colors.black,
          activeDayColor: Colors.deepPurple,
          activeBackgroundDayColor: Colors.white,
          dotColor: Colors.deepPurple,
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirestoreUtils.getRealTimeDataFromFirestore(selectedDate),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Text('Error Eccoured');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                );
              }
              var tasksList = snapshot.data?.docs.map((e) => e.data()).toList();
              return ListView.builder(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                itemBuilder: (context, index) => TaskItemWidget(
                  model: tasksList![index],
                ),
                itemCount: tasksList?.length ?? 0,
              );
            },
          ),
        ),
      ],
    );
  }
}
