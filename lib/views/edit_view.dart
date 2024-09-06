import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_task/core/network/firestore_utils.dart';
import 'package:todo_task/model/task_model.dart';

class EditView extends StatefulWidget {
  const EditView({
    super.key,
  });

  static const String routeName = 'edit_screen';

  // final TaskModel model;

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    var args = ModalRoute.of(context)!.settings.arguments as TaskModel;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 40, left: 20),
            width: mediaQuery.width,
            height: mediaQuery.height * 0.15,
            color: Colors.deepPurple,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'To Do List',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            height: mediaQuery.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Edit tasks",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.002,
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
                  height: mediaQuery.height * 0.01,
                ),
                TextFormField(
                  initialValue: args.title,
                  onChanged: (value) {
                    args.title = value;
                  },
                  //controller: titleController,
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
                  height: mediaQuery.height * 0.01,
                ),
                TextFormField(
                  initialValue: args.description,
                  onChanged: (value) {
                    args.description = value;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description can't be empty";
                    } else {
                      return null;
                    }
                  },
                  minLines: 3,
                  maxLines: 3,
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
                  height: mediaQuery.height * 0.01,
                ),
                const Text(
                  "Select Time",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.fromMillisecondsSinceEpoch(
                                args.dateTime!),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365))) ??
                        DateTime.now();
                    setState(() {
                      args.dateTime = selectedDate.millisecondsSinceEpoch;
                    });
                  },
                  child: Text(
                    (DateFormat.yMMMEd().format(selectedDate)),
                    //"${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.08,
                ),
                ElevatedButton(
                  onPressed: () {
                    FirestoreUtils.updateTask(args);
                    Navigator.pop(context);

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
