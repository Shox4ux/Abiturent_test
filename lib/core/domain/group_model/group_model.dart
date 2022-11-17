class GroupModel {
  int? status;
  String? message;
  Group? group;

  GroupModel({this.status, this.message, this.group});

  GroupModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    group = json['group'] != null ? Group.fromJson(json['group']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (group != null) {
      data['group'] = group!.toJson();
    }
    return data;
  }
}

class Group {
  int? id;
  String? groupCreated;
  String? subjectTitle;
  String? groupTitle;
  int? membersCount;
  List<MembersArray>? membersArray;

  Group(
      {this.id,
      this.groupCreated,
      this.subjectTitle,
      this.groupTitle,
      this.membersCount,
      this.membersArray});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupCreated = json['group_created'];
    subjectTitle = json['subject_title'];
    groupTitle = json['group_title'];
    membersCount = json['members_count'];
    if (json['members_array'] != null) {
      membersArray = <MembersArray>[];
      json['members_array'].forEach((v) {
        membersArray!.add(MembersArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['group_created'] = groupCreated;
    data['subject_title'] = subjectTitle;
    data['group_title'] = groupTitle;
    data['members_count'] = membersCount;
    if (membersArray != null) {
      data['members_array'] = membersArray!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MembersArray {
  int? id;
  int? userId;
  String? fullname;
  int? rating;
  int? type;
  String? created;
  String? groupTitle;
  String? subjectTitle;

  MembersArray(
      {this.id,
      this.userId,
      this.fullname,
      this.rating,
      this.type,
      this.created,
      this.groupTitle,
      this.subjectTitle});

  MembersArray.fromJson(Map<String, dynamic> json) {
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
