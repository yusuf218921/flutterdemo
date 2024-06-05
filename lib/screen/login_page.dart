// ignore_for_file: file_names
import 'package:flutterdemo/models/User.dart';
import 'package:flutterdemo/screen/forgot_password_page.dart';
import 'package:flutterdemo/screen/register_page.dart';
import 'package:flutterdemo/styles/button.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/screen/home_page.dart';
import 'package:flutterdemo/database/database_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void goToForgotPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
    );
  }

  void goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void _login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    // DatabaseHelper kullanarak kullanıcı adı ve şifre kontrolü yapalım
    User? user = await DatabaseHelper.instance.getUserByUsername(username);

    if (!mounted) return;

    if (user != null && user.password == password) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Username or password is wrong'),
                  Text('Please try again.'),
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

  @override
  Widget build(BuildContext context) {
    // Giriş sayfasının tasarımını oluşturun
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
                    "Login",
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
                                controller: usernameController,
                                decoration: const InputDecoration(
                                    hintText: "Username",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[200]!))),
                              child: TextField(
                                obscureText: true,
                                controller: passwordController,
                                decoration: const InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InputChip(
                            label: const Text(
                              "Forgot Password?",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                            onPressed: goToForgotPasswordPage,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InputChip(
                            label: const Text(
                              "Don't have an account ?",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                            onPressed: goToRegisterPage,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: _login,
                          style: buttonPrimary,
                          child: const Text(
                            "Login",
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
