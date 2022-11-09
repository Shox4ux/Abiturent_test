class TestResult {
  int? id;
  int? userId;
  String? created;
  int? subjectId;
  int? testListId;
  int? testQuestionId;
  int? testAnswerId;
  int? correctAnswerId;
  int? isCorrect;

  TestResult(
      {this.id,
      this.userId,
      this.created,
      this.subjectId,
      this.testListId,
      this.testQuestionId,
      this.testAnswerId,
      this.correctAnswerId,
      this.isCorrect});

  TestResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    created = json['created'];
    subjectId = json['subject_id'];
    testListId = json['test_list_id'];
    testQuestionId = json['test_question_id'];
    testAnswerId = json['test_answer_id'];
    correctAnswerId = json['correct_answer_id'];
    isCorrect = json['is_correct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['created'] = created;
    data['subject_id'] = subjectId;
    data['test_list_id'] = testListId;
    data['test_question_id'] = testQuestionId;
    data['test_answer_id'] = testAnswerId;
    data['correct_answer_id'] = correctAnswerId;
    data['is_correct'] = isCorrect;
    return data;
  }
}
