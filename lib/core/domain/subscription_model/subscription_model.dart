class SubscriptionModel {
  int? subjectId;
  String? subjectName;
  String? subjectUpdated;
  int? subjectPrice;
  SubscriptionData? subscriptionData;

  SubscriptionModel(
      {this.subjectId,
      this.subjectName,
      this.subjectUpdated,
      this.subjectPrice,
      this.subscriptionData});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    subjectUpdated = json['subject_updated'];
    subjectPrice = json['subject_price'];
    subscriptionData = json['subscription_data'] != null
        ? SubscriptionData.fromJson(json['subscription_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['subject_updated'] = subjectUpdated;
    data['subject_price'] = subjectPrice;
    if (subscriptionData != null) {
      data['subscription_data'] = subscriptionData!.toJson();
    }
    return data;
  }
}

class SubscriptionData {
  int? id;
  int? userId;
  int? subjectId;
  String? created;
  int? amount;
  String? startDay;
  String? endDay;
  int? status;
  String? statusText;

  SubscriptionData(
      {this.id,
      this.userId,
      this.subjectId,
      this.created,
      this.amount,
      this.startDay,
      this.endDay,
      this.status,
      this.statusText});

  SubscriptionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    subjectId = json['subject_id'];
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
    data['created'] = created;
    data['amount'] = amount;
    data['start_day'] = startDay;
    data['end_day'] = endDay;
    data['status'] = status;
    data['status_text'] = statusText;
    return data;
  }
}
