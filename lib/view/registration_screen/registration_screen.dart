import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_app_sample/utils/color_constance.dart';
import 'package:todo_app_sample/utils/image_constance.dart';
import 'package:todo_app_sample/view/home_screen/home_screen.dart';
import 'package:todo_app_sample/view/login_screen/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 3, 53, 94),
        body: Form(
          key: formkey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(ImageConstance.LOGINSCREENIMAGE2),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: username,
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
                          return 'please enter a username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: password,
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
                          return 'please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Colors.orange.shade300,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.orange,
                          decorationThickness: 2,
                          fontSize: 17),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 193, 87, 122)),
                        child: TextButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final storedusername = prefs.get('username');
                                final storedpassword = prefs.get('password');
                                if (storedusername == username.text &&
                                    storedpassword == password.text) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Invalid username or password')));
                                }
                              }
                            },
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: ColorConstance.mainwhite,
                                  fontSize: 20),
                            ))),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dont have an account?',
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
                            'Create an Account?',
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
        ),
      ),
    );
  }
}
