import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app_sample/utils/app_sessions.dart';
import 'package:todo_app_sample/utils/color_constance.dart';
import 'package:todo_app_sample/view/finished_task_screen/finished_task_screen.dart';
import 'package:todo_app_sample/view/login_screen/login_screen.dart';
import 'package:todo_app_sample/view/task_adding_screen/task_adding_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? editingIndex = -1;
  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController addToListController = TextEditingController();
  var todotaskbox = Hive.box(AppSessions.TODOAPPBOX);
  var finishedTasksBox = Hive.box('finishedTasks');
  double _completionPercentage = 0.0;

  List todokeys = [];

  @override
  void initState() {
    super.initState();
    taskController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
    addToListController = TextEditingController();
    todokeys = todotaskbox.keys.toList();
    setState(() {});
  }

  void dispose() {
    taskController.dispose();
    dateController.dispose();
    timeController.dispose();
    addToListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 53, 94),
      appBar: AppBar(
        title: Text('ToDo App'),
        actions: [
          Icon(
            Icons.search,
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          PopupMenuButton(
            color: ColorConstance.mainblue,
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("Task Lists")),
              PopupMenuItem(child: Text("Add in Batch mode")),
              PopupMenuItem(child: Text("More Apps")),
              PopupMenuItem(child: Text("Send Feedback")),
              PopupMenuItem(child: Text("Invite Friends to the app")),
              PopupMenuItem(child: Text("Settings"))
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                children: [
                  Text(
                    'Hi Prajeesh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/17894674/pexels-photo-17894674/free-photo-of-portrait-of-woman-in-jacket.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                    radius: 25,
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('All Lists'),
            ),
            ListTile(
              leading: Icon(Icons.inbox),
              title: Text('Default'),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shopping'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Personal'),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Wishlist'),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinishedTaskScreen(),
                    ));
              },
              child: ListTile(
                leading: Icon(Icons.check),
                title: Text(
                  'Finished  (${finishedTasksBox.length})',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('New List'),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              },
              child: ListTile(
                leading: Icon(Icons.logout_outlined),
                title: Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "This Month",
                style: TextStyle(
                    color: Color.fromARGB(201, 182, 188, 5), fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  ///for editing
                  bool isEditing = editingIndex == index;

                  var currenttodo = todotaskbox.get(todokeys[index]);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        editingIndex = index;
                        taskController.text = currenttodo['task'];
                        dateController.text = currenttodo['date'];
                        timeController.text = currenttodo['time'];
                        addToListController.text = currenttodo['addtolist'];
                      });
                    },

                    /// for deleting the card
                    onLongPress: () => showDeleteDialog(context, index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorConstance.mainblue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              /// checkbox section

                              Checkbox(
                                side:
                                    BorderSide(color: ColorConstance.mainwhite),
                                value: currenttodo['completed'] ?? false,
                                onChanged: (value) {
                                  if (value == true) {
                                    // Add task to finished tasks list
                                    var finishedTasksBox =
                                        Hive.box('finishedTasks');
                                    finishedTasksBox.put(
                                        todokeys[index], currenttodo);

                                    // Remove task from todo list
                                    todotaskbox.delete(todokeys[index]);
                                    todokeys.removeAt(index);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                ColorConstance.mainred,
                                            content: Text("Task Completed")));

                                    setState(() {});
                                  } else {
                                    currenttodo['completed'] = value;
                                    todotaskbox.put(
                                        todokeys[index], currenttodo);
                                  }
                                },
                              ),

                              ///for task writing section editing or not
                              Expanded(
                                child: isEditing
                                    ? TextField(
                                        controller: taskController,
                                        style: TextStyle(
                                          color: ColorConstance.mainwhite,
                                          fontSize: 20,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Task",
                                          hintStyle: TextStyle(
                                            color: Colors.white70,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      )
                                    : Text(
                                        currenttodo['task'],
                                        style: TextStyle(
                                          color: ColorConstance.mainwhite,
                                          fontSize: 20,
                                        ),
                                      ),
                              ),

                              /// for saving the edited data
                              if (isEditing)
                                IconButton(
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      currenttodo['task'] = taskController.text;
                                      currenttodo['date'] = dateController.text;
                                      currenttodo['time'] = timeController.text;
                                      currenttodo['addtolist'] =
                                          addToListController.text;
                                      todotaskbox.put(
                                          todokeys[index], currenttodo);

                                      todotaskbox.put(
                                          todokeys[index], currenttodo);

                                      editingIndex = null;
                                    });
                                  },
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Row(
                              children: [
                                Expanded(
                                  /// for date editing card
                                  child: isEditing
                                      ? TextField(
                                          controller: dateController,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 17,
                                          ),
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                onPressed: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2101),
                                                  );
                                                  if (pickedDate != null &&
                                                      pickedDate !=
                                                          dateController) {
                                                    setState(() {
                                                      dateController.text =
                                                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                                    });
                                                  } else {
                                                    null;
                                                  }
                                                },
                                                icon:
                                                    Icon(Icons.calendar_month)),
                                            hintText: "Date",
                                            hintStyle: TextStyle(
                                              color: Colors.white70,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        )
                                      : Text(
                                          currenttodo['date'],
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                201, 182, 188, 5),
                                            fontSize: 17,
                                          ),
                                        ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  /// for editing time section
                                  child: isEditing
                                      ? TextField(
                                          controller: timeController,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 17,
                                          ),
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                onPressed: () async {
                                                  final TimeOfDay? picked =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );
                                                  if (picked != null &&
                                                      picked !=
                                                          timeController) {
                                                    setState(() {
                                                      timeController.text =
                                                          picked
                                                              .format(context);
                                                    });
                                                  }
                                                },
                                                icon: Icon(
                                                    Icons.access_time_rounded)),
                                            hintText: "Time",
                                            hintStyle: TextStyle(
                                              color: Colors.white70,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        )
                                      : Text(
                                          currenttodo['time'],
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                201, 182, 188, 5),
                                            fontSize: 17,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),

                            /// for editing  add to list section
                            child: Row(
                              children: [
                                isEditing
                                    ? TextField(
                                        controller: addToListController,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Add to List",
                                          hintStyle: TextStyle(
                                            color: Colors.white70,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      )
                                    : Text(
                                        currenttodo['addtolist'],
                                        style: TextStyle(
                                          color: ColorConstance.mainwhite,
                                          fontSize: 20,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: todokeys.length,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 40,
            child: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskAddingScreen())).then(
                  (value) {
                    setState(() {});
                    todokeys = todotaskbox.keys.toList();
                  },
                );
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  /// for deleting section code

  void showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                setState(() {
                  todotaskbox.delete(todokeys[index]);
                  todokeys = todotaskbox.keys.toList();
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
