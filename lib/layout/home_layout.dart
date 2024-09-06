import 'package:flutter/material.dart';
import 'package:todo_task/layout/widgets/add_task_bottom_sheet.dart';
import 'package:todo_task/views/tasks_view.dart';

class HomeLayout extends StatefulWidget {
  static const String routeName = "home";
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int selectedIndex = 0;

  List<Widget> screensList = [
    const TasksView(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screensList[selectedIndex],
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        onPressed: () {
          showAddTasksBottomSheet();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 90,
        color: Colors.deepPurple,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "tasks"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "settings"),
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: const IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          unselectedIconTheme: const IconThemeData(
            color: Colors.grey,
            size: 30,
          ),
        ),
      ),
    );
  }
  showAddTasksBottomSheet() {
    showModalBottomSheet(
      context: context,
      //isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => const AddTaskBottomSheet(),
    );
  }

}
