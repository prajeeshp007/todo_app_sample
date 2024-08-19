import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';

import 'package:todo_app_sample/utils/app_sessions.dart';
import 'package:todo_app_sample/utils/color_constance.dart';

class TaskAddingScreen extends StatefulWidget {
  const TaskAddingScreen({
    super.key,
  });

  @override
  State<TaskAddingScreen> createState() => _TaskAddingScreenState();
}

class _TaskAddingScreenState extends State<TaskAddingScreen> {
  var todotaskbox = Hive.box(AppSessions.TODOAPPBOX);
  TextEditingController taskcontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();

  List<String> dropdownItems = [
    'No repeat',
    'Once a Day (Mon to Fri)',
    'Once a Week',
    'Once a Month',
    'Once a Year',
  ];
  List<String> dropdownItems2 = [
    'Default',
    'Personal',
    'Shopping',
    'Wishlist',
    'Work',
  ];

  String? repeatitems;
  String? addtolistitems;
  bool isDateSelected = false;
  @override
  void initState() {
    repeatitems = dropdownItems.first;
    addtolistitems = dropdownItems2.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 53, 94),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 92, 165),
        title: Text(
          'New Task',
          style: TextStyle(
              color: ColorConstance.mainwhite, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What is to be done?',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(201, 182, 188, 5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                style: TextStyle(color: ColorConstance.mainwhite),
                controller: taskcontroller,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Enter Task Here',
                    hintStyle: TextStyle(
                        color: ColorConstance.mainwhite.withOpacity(.5)),
                    suffixIcon: Icon(
                      Icons.mic,
                      color: ColorConstance.mainwhite,
                    )),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Due Date',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(201, 182, 188, 5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  style: TextStyle(color: ColorConstance.mainwhite),
                  controller: datecontroller,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Date not set',
                    hintStyle: TextStyle(
                        color: ColorConstance.mainwhite.withOpacity(.5)),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            datecontroller.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            setState(() {
                              isDateSelected = true;
                            });
                          } else {
                            isDateSelected = false;
                          }
                        },
                        icon: Icon(
                          Icons.calendar_month,
                          color: ColorConstance.mainwhite,
                        )),
                  )),
              SizedBox(
                height: 20,
              ),
              if (isDateSelected)
                SizedBox(
                  height: 10,
                ),
              TextFormField(
                  style: TextStyle(color: ColorConstance.mainwhite),
                  controller: timecontroller,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Time not set',
                    hintStyle: TextStyle(
                        color: ColorConstance.mainwhite.withOpacity(.5)),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            timecontroller.text = pickedTime.format(context);
                          }
                        },
                        icon: Icon(
                          Icons.access_time,
                          color: ColorConstance.mainwhite,
                        )),
                  )),
              SizedBox(
                height: 40,
              ),
              Text(
                'Repeat',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(201, 182, 188, 5),
                ),
              ),
              DropdownButton(
                dropdownColor: Color.fromARGB(255, 3, 53, 94),
                value: repeatitems,
                items: List.generate(
                  dropdownItems.length,
                  (index) => DropdownMenuItem(
                      value: dropdownItems[index],
                      child: Text(
                        dropdownItems[index],
                        style: TextStyle(color: ColorConstance.mainwhite),
                      )),
                ),
                onChanged: (value) {
                  repeatitems = value;
                  setState(() {});
                },
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Add to List',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(201, 182, 188, 5),
                ),
              ),
              DropdownButton(
                dropdownColor: Color.fromARGB(255, 3, 53, 94),
                value: addtolistitems,
                items: List.generate(
                  dropdownItems2.length,
                  (index) => DropdownMenuItem(
                      value: dropdownItems2[index],
                      child: Text(
                        dropdownItems2[index],
                        style: TextStyle(color: ColorConstance.mainwhite),
                      )),
                ),
                onChanged: (value) {
                  addtolistitems = value;
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        child: Icon(Icons.done_outline_rounded),
        onPressed: () {
          if (taskcontroller.text.isNotEmpty) {
            todotaskbox.add({
              'task': taskcontroller.text,
              'repeat': repeatitems,
              'addtolist': addtolistitems,
              'date': datecontroller.text,
              'time': timecontroller.text,
            });
            Navigator.pop(context);
          }
          // todotaskbox.add(
          //   {
          //     'task': taskcontroller.text,
          //     'repeat': repeatitems,
          //     'addtolist': addtolistitems,
          //     'date': datecontroller.text,
          //     'time': timecontroller.text,
          //   },
          // );
        },
      ),
    );
  }
}
