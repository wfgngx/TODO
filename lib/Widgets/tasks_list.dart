import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_route/Models/task_model.dart';
import 'package:todo_route/Network/local/FireBase/firebase_function.dart';

class Tasks extends StatefulWidget {
  const Tasks({
    required this.dateTime,
    Key? key,
  }) : super(key: key);
  final DateTime dateTime;

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.dateTime;

    return Padding(
        padding: const EdgeInsets.only(top: 0, left: 4, right: 4),
        child: StreamBuilder(
          stream: FirebaseFunctions.getTasks(dateTime),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              const Text("Something went wrong...");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              const CircularProgressIndicator();
            }
            var tasks = snapshot.data?.docs.map((e) => e.data()).toList() ?? [];
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                height: 8,
              ),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return taskContainer(tasks[index], widget.dateTime);
              },
            );
          },
        ));
  }

  Widget taskContainer(TaskModel taskModel, DateTime dateTime) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 5,
      child: Slidable(
        startActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), bottomLeft: Radius.circular(18)),
            onPressed: (context) async {
              // print("${taskModel.id}from click update");
              TaskModel task = TaskModel(
                  title: taskModel.title,
                  isDone: true,
                  date: DateUtils.dateOnly(dateTime).millisecondsSinceEpoch,
                  description: taskModel.description);
              await FirebaseFunctions.updateTask(taskModel.id, task)
                  .then((value) {
                // print("${taskModel.id}from updated");
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.blue,
                    content: Text("Task Updated Successfully")));
                Navigator.pop(context);
              });
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.done,
            label: 'Done',
          ),
          SlidableAction(
            onPressed: (context) async {
              // print("${taskModel.id}from click edit");
              return await showAlertDialog(
                taskModel,
                taskModel.title,
                taskModel.description,
                dateTime,
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'edit',
          ),
        ]),
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18)),
            onPressed: (context) {
              FirebaseFunctions.deleteTask(taskModel.id);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ]),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(18)),
          // height: 100,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 80,
                decoration: BoxDecoration(
                    color: taskModel.isDone == false
                        ? Colors.blue
                        : const Color(0xFF61E757),
                    borderRadius: BorderRadius.circular(32)),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskModel.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: taskModel.isDone == false
                          ? Colors.blue
                          : const Color(0xFF61E757),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Stack(
                    children: [
                      Text(
                        taskModel.description,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      Positioned(
                          top: 9,
                          child: Container(
                            width: 100,
                            color: taskModel.isDone == true
                                ? Colors.black54
                                : Colors.transparent,
                            height: 3,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 75,
                height: 40,
                decoration: BoxDecoration(
                    color: taskModel.isDone == false
                        ? Colors.blue
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12)),
                child: taskModel.isDone == true
                    ? const Center(
                        child: Text(
                        'Done!',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF61E757)),
                      ))
                    : const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 40,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAlertDialog(
    TaskModel taskModel,
    String title,
    String description,
    DateTime date,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text("Edit Task"),
              TextFormField(
                onChanged: (value) {
                  title = value;
                  setState(() {});
                },
                initialValue: title,
              ),
              TextFormField(
                initialValue: description,
                onChanged: (value) {
                  description = value;
                  setState(() {});
                },
              ),
              InkWell(
                onTap: () {
                  showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now());
                },
                child: Text(date.toString().substring(0, 10)),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  print("${taskModel.id}from click update");
                  TaskModel task = TaskModel(
                      title: title,
                      date: DateUtils.dateOnly(date).millisecondsSinceEpoch,
                      description: description);
                  await FirebaseFunctions.updateTask(taskModel.id, task)
                      .then((value) {
                    print("${taskModel.id}from updated");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text("Task Updated Successfully")));
                    Navigator.pop(context);
                  });
                },
                child: const Text("Update")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"))
          ],
        );
      },
    );
  }
}
