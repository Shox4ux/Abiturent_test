class TestModel {
  Subjects? subjects;
  List<Tests>? tests;

  TestModel({this.subjects, this.tests});

  TestModel.fromJson(Map<String, dynamic> json) {
    subjects =
        json['subjects'] != null ? Subjects.fromJson(json['subjects']) : null;
    if (json['tests'] != null) {
      tests = <Tests>[];
      json['tests'].forEach((v) {
        tests!.add(Tests.fromJson(v));
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
  String? image;
  int? price;
  int? updated;
  String? updatedDate;
  int? testLimit;

  Subjects(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.updated,
      this.updatedDate,
      this.testLimit});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    updated = json['updated'];
    updatedDate = json['updated_date'];
    testLimit = json['test_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['price'] = price;
    data['updated'] = updated;
    data['updated_date'] = updatedDate;
    data['test_limit'] = testLimit;
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
  num? percent;
  String? testType;
  List<Books>? books;

  Tests(
      {this.id,
      this.created,
      this.createdDate,
      this.subjectId,
      this.subjectName,
      this.type,
      this.typeText,
      this.title,
      this.status,
      this.statusText,
      this.questionsCount,
      this.percent,
      this.testType,
      this.books});

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
    percent = json['percent'];
    testType = json['test_type'];
    if (json['books'] != null) {
      books = <Books>[];
      json['books'].forEach((v) {
        books!.add(new Books.fromJson(v));
      });
    }
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
    data['percent'] = percent;
    data['test_type'] = testType;
    if (books != null) {
      data['books'] = books!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Books {
  int? id;
  String? title;
  int? testListId;
  int? subjectId;
  String? subjectText;
  String? files;

  Books(
      {this.id,
      this.title,
      this.testListId,
      this.subjectId,
      this.subjectText,
      this.files});

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    testListId = json['test_list_id'];
    subjectId = json['subject_id'];
    subjectText = json['subject_text'];
    files = json['files'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['test_list_id'] = testListId;
    data['subject_id'] = subjectId;
    data['subject_text'] = subjectText;
    data['files'] = files;
    return data;
  }
}
