// ignore_for_file: file_names

class Option {
  int? optionId;
  int questionId;
  String optionText;
  bool isCorrect;

  Option(
      {this.optionId,
      required this.questionId,
      required this.optionText,
      required this.isCorrect});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'questionId': questionId,
      'optionText': optionText,
      'isCorrect': isCorrect ? 1 : 0,
    };
    if (optionId != null) {
      map['optionId'] = optionId;
    }
    return map;
  }

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      optionId: map['optionId'],
      questionId: map['questionId'],
      optionText: map['optionText'],
      isCorrect: map['isCorrect'] == 1,
    );
  }
}
