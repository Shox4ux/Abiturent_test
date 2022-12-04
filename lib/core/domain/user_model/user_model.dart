class UserInfo {
  int? id;
  String? username;
  String? fullname;
  String? createdAt;
  int? status;
  String? statusText;
  int? balance;
  int? role;
  String? roleText;
  int? rating;
  int? ratingMonth;
  String? smsLive;
  String? image;
  int? medalId;
  String? telegramLink;

  UserInfo({
    this.id,
    this.username,
    this.fullname,
    this.createdAt,
    this.status,
    this.statusText,
    this.balance,
    this.role,
    this.roleText,
    this.rating,
    this.ratingMonth,
    this.smsLive,
    this.image,
    this.medalId,
    this.telegramLink,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullname = json['fullname'];
    createdAt = json['created_at'];
    status = json['status'];
    statusText = json['status_text'];
    balance = json['balance'];
    role = json['role'];
    roleText = json['role_text'];
    rating = json['rating'];
    ratingMonth = json['rating_month'];
    smsLive = json['sms_live'];
    image = json['image'];
    medalId = json['medal_id'];
    telegramLink = json['telegram_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['fullname'] = fullname;
    data['created_at'] = createdAt;
    data['status'] = status;
    data['status_text'] = statusText;
    data['balance'] = balance;
    data['role'] = role;
    data['role_text'] = roleText;
    data['rating'] = rating;
    data['rating_month'] = ratingMonth;
    data['sms_live'] = smsLive;
    data['image'] = image;
    data['medal_id'] = medalId;
    data['telegram_link'] = telegramLink;
    return data;
  }
}
