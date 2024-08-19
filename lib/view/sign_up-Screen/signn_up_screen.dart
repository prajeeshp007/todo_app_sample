import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_sample/utils/color_constance.dart';
import 'package:todo_app_sample/utils/image_constance.dart';
import 'package:todo_app_sample/view/login_screen/login_screen.dart';
import 'package:todo_app_sample/view/registration_screen/registration_screen.dart';

class SignnUpScreen extends StatefulWidget {
  const SignnUpScreen({super.key});

  @override
  State<SignnUpScreen> createState() => _SignnUpScreenState();
}

class _SignnUpScreenState extends State<SignnUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController savedusername = TextEditingController();
  TextEditingController savedPassword = TextEditingController();
  TextEditingController savedPassword1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 3, 53, 94),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(ImageConstance.LOGINSCREENIMAGE4),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: savedusername,
                    decoration: InputDecoration(
                      suffix: Icon(
                        Icons.person_2,
                        color: ColorConstance.mainblack,
                        size: 25,
                      ),
                      filled: true,
                      fillColor: ColorConstance.mainwhite,
                      hintText: 'User Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter a username ';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: savedPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: ColorConstance.mainblack,
                        ),
                        filled: true,
                        fillColor: ColorConstance.mainwhite,
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                        focusColor: ColorConstance.mainred),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter a password ';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: savedPassword1,
                    obscureText: true,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: ColorConstance.mainblack,
                        ),
                        filled: true,
                        fillColor: ColorConstance.mainwhite,
                        hintText: 'Conform Password',
                        border: OutlineInputBorder(),
                        focusColor: ColorConstance.mainred),
                    validator: (value) {
                      if (savedPassword.text == savedPassword1.text) {
                        return null;
                      } else {
                        return 'Password does not match ';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 193, 87, 122)),
                      child: TextButton(
                          onPressed: () async {
                            /// this is the condition to save the typing password
                            if (_formKey.currentState!.validate()) {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('username', savedusername.text);
                              prefs.setString('password', savedPassword.text);
                              prefs.setString('password', savedPassword1.text);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistrationScreen(),
                                  ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('invalid details')));
                            }
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: ColorConstance.mainwhite, fontSize: 20),
                          ))),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                          color: ColorConstance.maingrey, fontSize: 15),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      child: Text(
                        'Sign In?',
                        style: TextStyle(
                            color: ColorConstance.mainblue, fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
