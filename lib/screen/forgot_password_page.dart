import 'package:flutter/material.dart';
import 'package:flutterdemo/database/database_helper.dart';
import 'package:flutterdemo/models/User.dart';
import 'package:flutterdemo/screen/login_page.dart';
import 'package:flutterdemo/styles/button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  void showPassword() async {
    String email = emailController.text;

    User? user = await DatabaseHelper.instance.getUserByEmail(email);

    if (!mounted) {
      return;
    }

    if (user != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(user.password),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("User not found"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void backToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 90, 12, 1),
              Color.fromARGB(255, 161, 4, 4),
              Color.fromARGB(255, 201, 5, 5)
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Quizle",
                        style: TextStyle(
                            color: Color.fromARGB(255, 204, 184, 5),
                            fontSize: 40,
                            fontFamily: "alev",
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                        color: Colors.white, fontSize: 20, fontFamily: "alev"),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60.0),
                      topRight: Radius.circular(60.0)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 60,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(122, 3, 3, 0.992),
                                  blurRadius: 20,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[200]!))),
                              child: TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                    hintText: "email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputChip(
                        label: const Text(
                          "Back to the login",
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: backToLogin,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: showPassword,
                          style: buttonPrimary,
                          child: const Text(
                            "Show Password",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
