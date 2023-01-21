class InnerTestModel {
  int? id;
  int? created;
  String? createdDate;
  int? testListId;
  String? subjectName;
  String? testName;
  String? content;
  int? prior;
  List<Answers>? answers;
  String? image;

  InnerTestModel(
      {this.id,
      this.created,
      this.createdDate,
      this.testListId,
      this.subjectName,
      this.testName,
      this.content,
      this.prior,
      this.answers});

  InnerTestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdDate = json['created_date'];
    testListId = json['test_list_id'];
    subjectName = json['subject_name'];
    testName = json['test_name'];
    content = json['content'];
    prior = json['prior'];
    if (json['answers_array'] != null) {
      answers = [];
      json['answers_array'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created'] = created;
    data['created_date'] = createdDate;
    data['test_list_id'] = testListId;
    data['subject_name'] = subjectName;
    data['test_name'] = testName;
    data['content'] = content;
    data['prior'] = prior;
    if (answers != null) {
      data['answers_array'] = answers!.map((v) => v.toJson()).toList();
    }
    data['image'] = image;
    return data;
  }
}

class Answers {
  int? id;
  String? content;

  Answers({this.id, this.content});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    return data;
  }
}
