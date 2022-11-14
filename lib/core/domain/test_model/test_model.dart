class TestModel {
  Subjects? subjects;
  List<Tests>? tests;

  TestModel({
    required this.subjects,
    required this.tests,
  });

  TestModel.fromJson(Map<String, dynamic> json) {
    subjects = (json['subjects'] != null
        ? Subjects.fromJson(json['subjects'])
        : null)!;
    if (json['tests'] != null) {
      tests = <Tests>[];
      json['tests'].forEach((v) {
        tests?.add(Tests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subjects != null) {
      data['subjects'] = subjects!.toJson();
    }
    if (tests != null) {
      data['tests'] = tests!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Subjects {
  int? id;
  String? name;
  String? alias;
  int? price;
  int? updated;
  String? updatedDate;

  Subjects(
      {required this.id,
      required this.name,
      required this.alias,
      required this.price,
      required this.updated,
      required this.updatedDate});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    price = json['price'];
    updated = json['updated'];
    updatedDate = json['updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['alias'] = alias;
    data['price'] = price;
    data['updated'] = updated;
    data['updated_date'] = updatedDate;
    return data;
  }
}

class Tests {
  int? id;
  int? created;
  String? createdDate;
  int? subjectId;
  String? subjectName;
  int? type;
  String? typeText;
  String? title;
  int? status;
  String? statusText;
  int? questionsCount;

  Tests(
      {required this.id,
      required this.created,
      required this.createdDate,
      required this.subjectId,
      required this.subjectName,
      required this.type,
      required this.typeText,
      required this.title,
      required this.status,
      required this.statusText,
      required this.questionsCount});

  Tests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdDate = json['created_date'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    type = json['type'];
    typeText = json['type_text'];
    title = json['title'];
    status = json['status'];
    statusText = json['status_text'];
    questionsCount = json['questions_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created'] = created;
    data['created_date'] = createdDate;
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['type'] = type;
    data['type_text'] = typeText;
    data['title'] = title;
    data['status'] = status;
    data['status_text'] = statusText;
    data['questions_count'] = questionsCount;
    return data;
  }
}
