import 'package:flutter/material.dart';
import 'package:flutterdemo/models/Quiz.dart';
import 'package:flutterdemo/screen/quiz_page.dart';
import 'package:flutterdemo/database/database_helper.dart'; // DatabaseHelper import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Quiz> list = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  void _loadQuizzes() async {
    List<Quiz> quizzes = await DatabaseHelper.instance.getAllQuizzes();
    if (mounted) {
      setState(() {
        list = quizzes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quizle',
          style:
              TextStyle(color: Colors.yellow, fontFamily: "alev", fontSize: 28),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            Quiz quiz = list[index];
            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    quiz.quizImgUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  quiz.quizName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(quiz: quiz),
                      ),
                    );
                  },
                  child: const Text('Başla'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
