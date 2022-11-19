class MadeScript {
  int? id;
  int? userId;
  int? subjectId;
  String? subjectText;
  String? created;
  int? amount;
  String? startDay;
  String? endDay;
  int? status;
  String? statusText;

  MadeScript(
      {this.id,
      this.userId,
      this.subjectId,
      this.subjectText,
      this.created,
      this.amount,
      this.startDay,
      this.endDay,
      this.status,
      this.statusText});

  MadeScript.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    subjectId = json['subject_id'];
    subjectText = json['subject_text'];
    created = json['created'];
    amount = json['amount'];
    startDay = json['start_day'];
    endDay = json['end_day'];
    status = json['status'];
    statusText = json['status_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['subject_id'] = subjectId;
    data['subject_text'] = subjectText;
    data['created'] = created;
    data['amount'] = amount;
    data['start_day'] = startDay;
    data['end_day'] = endDay;
    data['status'] = status;
    data['status_text'] = statusText;
    return data;
  }
}
