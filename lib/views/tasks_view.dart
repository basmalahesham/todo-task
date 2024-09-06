import 'package:flutter/cupertino.dart';
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
          padding: EdgeInsets.only(top: 40, left: 20),
          width: mediaQuery.width,
          height: mediaQuery.height * 0.15,
          color: Colors.deepPurple,
          child: Text(
            'To Do List',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
/*
        CalendarTimeline(
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(Duration(days: 30)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) {
            selectedDate = date;
            setState(() {});
          },
          leftMargin: 20,
          monthColor: provider.isDark() ? Colors.white : Colors.black,
          dayColor: provider.isDark() ? Colors.white : Colors.black,
          activeDayColor:
          provider.isDark() ? Colors.white : AppTheme.primaryColor,
          activeBackgroundDayColor:
          provider.isDark() ? Color(0xFF141922) : Colors.white,
          dotColor: provider.isDark() ? Colors.white : AppTheme.primaryColor,
        ),
*/
        Expanded(
          child: StreamBuilder(
            stream: FirestoreUtils.getRealTimeDataFromFirestore(selectedDate),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error Eccoured');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                );
              }
              var tasksList = snapshot.data?.docs.map((e) => e.data()).toList();
              return ListView.builder(
                padding: EdgeInsets.only(
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
