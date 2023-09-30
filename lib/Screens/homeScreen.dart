import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo_route/Screens/settings.dart';
import 'package:todo_route/Screens/task_body.dart';
import 'package:todo_route/Widgets/tasks_list.dart';
import '../Widgets/task_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabsBottomNAV = [ TaskBody(), const Settings()];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
                side: const BorderSide(color: Colors.white)),
            child: const Icon(
              Icons.add_task,
              color: Colors.white,
            ),
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  builder: (context) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: const ShowTaskkBottomSheet()));
            }),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          clipBehavior: Clip.hardEdge,
          notchMargin: 8,
          color: Colors.white,
          elevation: 50,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              currentIndex = index;
              setState(() {});
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Setting'),
            ],
          ),
        ),
        body: tabsBottomNAV[currentIndex]);
  }
}
