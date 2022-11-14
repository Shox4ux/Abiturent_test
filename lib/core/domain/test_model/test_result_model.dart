class TestResult {
  int? questionId;
  String? questionContent;
  List<AnswersDetail>? answersDetail;

  TestResult({this.questionId, this.questionContent, this.answersDetail});

  TestResult.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    questionContent = json['question_content'];
    if (json['answers_detail'] != null) {
      answersDetail = <AnswersDetail>[];
      json['answers_detail'].forEach((v) {
        answersDetail!.add(AnswersDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['question_content'] = questionContent;
    if (answersDetail != null) {
      data['answers_detail'] = answersDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnswersDetail {
  int? answerId;
  String? content;
  int? selectedAnswer;
  int? isCorrect;
  int? correctAnswer;

  AnswersDetail(
      {this.answerId,
      this.content,
      this.selectedAnswer,
      this.isCorrect,
      this.correctAnswer});

  AnswersDetail.fromJson(Map<String, dynamic> json) {
    answerId = json['answer_id'];
    content = json['content'];
    selectedAnswer = json['selected_answer'];
    isCorrect = json['is_correct'];
    correctAnswer = json['correct_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['answer_id'] = answerId;
    data['content'] = content;
    data['selected_answer'] = selectedAnswer;
    data['is_correct'] = isCorrect;
    data['correct_answer'] = correctAnswer;
    return data;
  }
}
