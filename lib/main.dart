import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sample_project/homepage.dart';
import 'package:sample_project/signup_page.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var useController = TextEditingController();
  var passController = TextEditingController();
  bool _validate = false;
  bool _validate1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 160,
              child: const Center(
                child: Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[300],
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: TextField(
                        controller: useController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          contentPadding: EdgeInsets.all(10),
                         errorText: _validate ? "fill username" : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: TextField(
                        controller: passController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          contentPadding: EdgeInsets.all(10),
                         errorText: _validate1 ? "fill password" : null,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        var connectivityResult = await Connectivity().checkConnectivity();
                        if (connectivityResult == ConnectivityResult.none) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("No Internet Connection"),
                                content: Text("Please check your internet connection."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        var use = useController.text.toString();
                        var pass = passController.text.toString();

                        if (use.isEmpty) {
                          // Show error message if username field is empty
                          setState(() {
                            _validate = true;
                          });
                        } else if (pass.isEmpty) {
                          // Show error message if password field is empty
                          setState(() {
                            _validate1 = true;
                          });
                        } else {
                          // Both fields are filled, perform submission
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  HomePage(),
                            ),
                          );
                          useController.clear();
                          passController.clear();
                        }
                      },
                      child: Text('Submit', style: TextStyle(color: Colors.black87)),
                    ),

                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SecondRoute(),
                      ),
                    );
                  },
                  child: Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'forgot password',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
