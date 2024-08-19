import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app_sample/utils/color_constance.dart';
import 'package:todo_app_sample/utils/image_constance.dart';

class FinishedTaskScreen extends StatefulWidget {
  const FinishedTaskScreen({super.key});

  @override
  State<FinishedTaskScreen> createState() => _FinishedTaskScreenState();
}

class _FinishedTaskScreenState extends State<FinishedTaskScreen> {
  var finishedTasksBox = Hive.box('finishedTasks');
  List finishedTaskskey = [];
  @override
  void initState() {
    finishedTaskskey = finishedTasksBox.values.toList();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 74, 161, 233),
      appBar: AppBar(
        title: const Text('Finished Tasks'),
      ),
      body: Expanded(
        child: Column(
          children: [
            Image.asset(ImageConstance.LOGINSCREENIMAGE),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: finishedTasksBox.length,
                itemBuilder: (context, index) {
                  var task = finishedTasksBox.getAt(index);
                  return Card(
                    child: ListTile(
                      tileColor: ColorConstance.mainblue,
                      title: Text(
                        task['task'],
                        style: TextStyle(
                            color: ColorConstance.mainblack,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Completed on ${task['date']} at ${task['time']}',
                        style: TextStyle(
                            color: ColorConstance.mainblack,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
