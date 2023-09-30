import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';

import '../Widgets/tasks_list.dart';

class TaskBody extends StatefulWidget {
  TaskBody({Key? key}) : super(key: key);

  @override
  State<TaskBody> createState() => _TaskBodyState();
}

class _TaskBodyState extends State<TaskBody> {
  var selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          height: 200,
          padding: const EdgeInsets.fromLTRB(12, 30, 0, 0),
          decoration: const BoxDecoration(color: Colors.blue),
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 8,),
              const Text(
                "Tasks To Do",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              ),
              const SizedBox(
                height: 30,
              ),
              CalendarTimeline(
                  //todo كده اي يوم بيساوي ال  15 مش هيكون متاح اني اضيف فيه اي تاسك هيكون مش متفعل اصلا وبرده لونه باهت شويه
                  //todo selectableDayPredicate: (date) {
                  //todo   return date.day != 15;
                  //todo },
                  leftMargin: 10,
                  monthColor: Colors.white,
                  dayColor: Colors.white,
                  activeDayColor: Colors.blue,
                  activeBackgroundDayColor: Colors.white,
                  dotsColor: Colors.blue,
                  initialDate: selectedDate,
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365 * 2)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  onDateSelected: (data) {
                    selectedDate = data;
                    setState(() {});
                  }),
            ],
          )),
      Expanded(
          child: Tasks(
        dateTime: selectedDate,
      ))
    ]);
  }
}
