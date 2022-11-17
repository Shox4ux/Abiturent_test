class GroupItem {
  int? id;
  String? created;
  String? subjectTitle;
  String? title;
  int? memberCount;

  GroupItem(
      {this.id, this.created, this.subjectTitle, this.title, this.memberCount});

  GroupItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    subjectTitle = json['subject_title'];
    title = json['title'];
    memberCount = json['member_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['subject_title'] = this.subjectTitle;
    data['title'] = this.title;
    data['member_count'] = this.memberCount;
    return data;
  }
}
