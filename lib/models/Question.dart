// ignore_for_file: file_names

class Question {
  int? questionId;
  int quizId;
  String questionText;

  Question({this.questionId, required this.quizId, required this.questionText});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'quizId': quizId,
      'questionText': questionText,
    };
    if (questionId != null) {
      map['questionId'] = questionId;
    }
    return map;
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['questionId'],
      quizId: map['quizId'],
      questionText: map['questionText'],
    );
  }
}
