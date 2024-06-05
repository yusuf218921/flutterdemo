// ignore_for_file: file_names

class Quiz {
  int? quizId;
  String quizName;
  String quizImgUrl;

  Quiz({this.quizId, required this.quizName, required this.quizImgUrl});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'quizName': quizName,
      'quizImgUrl': quizImgUrl,
    };
    if (quizId != null) {
      map['quizId'] = quizId;
    }
    return map;
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      quizId: map['quizId'],
      quizName: map['quizName'],
      quizImgUrl: map['quizImgUrl'],
    );
  }
}
