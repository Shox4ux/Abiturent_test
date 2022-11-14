class ScriptPreview {
  SubjectData? subjectData;
  String? startDay;
  String? endDay;

  ScriptPreview({this.subjectData, this.startDay, this.endDay});

  ScriptPreview.fromJson(Map<String, dynamic> json) {
    subjectData = json['subject_data'] != null
        ? SubjectData.fromJson(json['subject_data'])
        : null;
    startDay = json['start_day'];
    endDay = json['end_day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subjectData != null) {
      data['subject_data'] = subjectData!.toJson();
    }
    data['start_day'] = startDay;
    data['end_day'] = endDay;
    return data;
  }
}

class SubjectData {
  int? id;
  String? name;
  int? price;
  int? updated;
  String? updatedDate;

  SubjectData({this.id, this.name, this.price, this.updated, this.updatedDate});

  SubjectData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    updated = json['updated'];
    updatedDate = json['updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['updated'] = updated;
    data['updated_date'] = updatedDate;
    return data;
  }
}
