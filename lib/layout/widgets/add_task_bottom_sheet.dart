import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:todo_task/core/network/firestore_utils.dart';
import 'package:todo_task/core/services/snackbar_service.dart';
import 'package:todo_task/model/task_model.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  //TextEditingController dueDateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Add New Task",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.001,
                ),
                const Text(
                  "Title",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.001,
                ),
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Title can't be empty";
                    } else if (value.length < 8) {
                      return "Title must be at least 8 characters";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Your Task Title',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.01,
                ),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.001,
                ),
                TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description can't be empty";
                    } else {
                      return null;
                    }
                  },
                  minLines: 2,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Task Description',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.001,
                ),
                Row(
                  children: [
                    const Text(
                      "Select Time :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        selectDateTime();
                      },
                      child: Text(
                        (DateFormat.yMMMEd().format(selectedDate)),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    addTask();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Add Task",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectDateTime() async {
    var currentDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );
    if (currentDate == null) {
      return;
    }
    selectedDate = currentDate;
    setState(() {});
  }

  void addTask() async {
    if (formKey.currentState!.validate()) {
      TaskModel taskModel = TaskModel(
        title: titleController.text,
        description: descriptionController.text,
        isDone: false,
        dateTime:
        (MyDateTime.externalDateOnly(selectedDate)).millisecondsSinceEpoch,
      );

      try {
        EasyLoading.show();
        await FirestoreUtils.addTask(taskModel);
        EasyLoading.dismiss();
        SnackBarService.showSuccessMessage('Task added successfully');
        Navigator.pop(context);
      } catch (e) {
        EasyLoading.dismiss();
        SnackBarService.showErrorMessage('Task added failed');
        Navigator.pop(context);
      }
    }
  }
}