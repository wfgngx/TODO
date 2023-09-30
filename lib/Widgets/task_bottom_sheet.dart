import 'package:flutter/material.dart';
import 'package:todo_route/Models/task_model.dart';
import 'package:todo_route/Network/local/FireBase/firebase_function.dart';

class ShowTaskkBottomSheet extends StatefulWidget {
  const ShowTaskkBottomSheet({Key? key}) : super(key: key);

  @override
  State<ShowTaskkBottomSheet> createState() => _ShowTaskkBottomSheetState();
}

class _ShowTaskkBottomSheetState extends State<ShowTaskkBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Center(
                    child: Text(
                  'Add new Task',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter task title';
                    }
                    return null;
                  },
                  controller: titleController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Title")),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter task description';
                    }
                    return null;
                  },
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Description")),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Select Date',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedDate.toString().substring(0, 10),
                      style: const TextStyle(color: Colors.black, fontSize: 22),
                    ),
                    IconButton(
                        onPressed: () async {
                          DateTime? chooseDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 2)));
                          if (chooseDate != null) {
                            selectedDate = chooseDate;
                            setState(() {});
                          } else {
                            chooseDate = DateTime.now();

                            selectedDate = chooseDate;
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
                InkWell(
                    onTap: () {
                      TaskModel task = TaskModel(
                        title: titleController.text,
                        date: DateUtils.dateOnly(selectedDate)
                            .millisecondsSinceEpoch,
                        description: descriptionController.text,
                      );
                      if (_formKey.currentState!.validate()) {
                        FirebaseFunctions.addTask(task);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                duration: Duration(milliseconds: 800),
                                content: Text("Task added successfully")));
                        setState(() {});
                        Navigator.pop(context);
                      }
                      // FirebaseFunctions.addTask(task);
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //     duration: Duration(milliseconds: 800),
                      //     content: Text("Task added successfully")));
                      // setState(() {});
                      // Navigator.pop(context);
                    },
                    child: Center(
                        child: Container(
                      width: 300,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )))
              ],
            ),
          ),
        ));
  }
}
