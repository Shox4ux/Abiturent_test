class GroupMemberModel {
  int? id;
  int? userId;
  String? fullname;
  int? rating;
  int? type;
  String? created;
  String? groupTitle;
  String? subjectTitle;

  GroupMemberModel(
      {this.id,
      this.userId,
      this.fullname,
      this.rating,
      this.type,
      this.created,
      this.groupTitle,
      this.subjectTitle});

  GroupMemberModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fullname = json['fullname'];
    rating = json['rating'];
    type = json['type'];
    created = json['created'];
    groupTitle = json['group_title'];
    subjectTitle = json['subject_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['fullname'] = fullname;
    data['rating'] = rating;
    data['type'] = type;
    data['created'] = created;
    data['group_title'] = groupTitle;
    data['subject_title'] = subjectTitle;
    return data;
  }
}
