import 'package:flutter/material.dart';
import 'package:flutterdemo/models/Option.dart';
import 'package:flutterdemo/models/Quiz.dart';
import 'package:flutterdemo/models/Question.dart';
import 'package:flutterdemo/screen/home_page.dart';
import 'package:flutterdemo/database/database_helper.dart'; // DatabaseHelper import

class QuizPage extends StatefulWidget {
  final Quiz quiz;

  const QuizPage({super.key, required this.quiz});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  final List<Option> _selectedOptions = [];
  int _score = 0;
  List<QuestionWithOptions> _questionsWithOptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestionsAndOptions();
  }

  void _loadQuestionsAndOptions() async {
    List<Question> questions =
        await DatabaseHelper.instance.getQuestionsByQuizId(widget.quiz.quizId!);
    List<QuestionWithOptions> questionsWithOptions = [];

    for (var question in questions) {
      List<Option> options = await DatabaseHelper.instance
          .getOptionsByQuestionId(question.questionId!);
      questionsWithOptions
          .add(QuestionWithOptions(question: question, options: options));
    }

    if (mounted) {
      setState(() {
        _questionsWithOptions = questionsWithOptions;
        _isLoading = false;
      });
    }
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questionsWithOptions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _calculateScore();
      }
    });
  }

  void _calculateScore() {
    _score = 0;
    for (int i = 0; i < _questionsWithOptions.length; i++) {
      if (_selectedOptions[i].isCorrect) {
        _score++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz', style: TextStyle(color: Colors.yellow)),
          backgroundColor: Colors.redAccent,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    var currentQuestionWithOptions =
        _questionsWithOptions[_currentQuestionIndex];
    var currentQuestion = currentQuestionWithOptions.question;
    var options = currentQuestionWithOptions.options;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quiz.quizName,
          style: const TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questionsWithOptions.length,
              backgroundColor: Colors.grey[200],
              color: Colors.redAccent,
            ),
            const SizedBox(height: 20),
            Text(
              'Soru ${_currentQuestionIndex + 1}/${_questionsWithOptions.length}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  currentQuestion.questionText,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                      padding: const EdgeInsets.all(16.0),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedOptions.add(option);
                        _nextQuestion();
                      });
                    },
                    child: Text(option.optionText),
                  ),
                );
              }).toList(),
            ),
            if (_currentQuestionIndex == _questionsWithOptions.length - 1)
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    child: const Text('Quiz\'i Bitir'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Puanınız: $_score / ${_questionsWithOptions.length}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class QuestionWithOptions {
  final Question question;
  final List<Option> options;

  QuestionWithOptions({required this.question, required this.options});
}
