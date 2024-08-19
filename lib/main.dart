import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_sample/utils/app_sessions.dart';

import 'package:todo_app_sample/view/splash_screen/splash_screen.dart';

Future<void> main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox(AppSessions.TODOAPPBOX);
  var box2 = await Hive.openBox('finishedTasks');

  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final isloggedin = prefs.getBool('isloggedin') ?? false;
  runApp(MyApp(
    isloggedin: isloggedin,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isloggedin});
  final bool isloggedin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
