class UserInfo {
  int? id;
  String? username;
  String? phone;
  String? fullname;
  String? createdAt;
  int? status;
  String? statusText;
  int? balance;
  int? role;
  String? roleText;
  int? rating;
  String? smsLive;
  String? image;
  int? medalId;
  String? medalImg;

  UserInfo(
      {this.id,
      this.username,
      this.phone,
      this.fullname,
      this.createdAt,
      this.status,
      this.statusText,
      this.balance,
      this.role,
      this.roleText,
      this.rating,
      this.smsLive,
      this.image,
      this.medalId,
      this.medalImg});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    phone = json['phone'];
    fullname = json['fullname'];
    createdAt = json['created_at'];
    status = json['status'];
    statusText = json['status_text'];
    balance = json['balance'];
    role = json['role'];
    roleText = json['role_text'];
    rating = json['rating'];
    smsLive = json['sms_live'];
    image = json['image'];
    medalId = json['medal_id'];
    medalImg = json['medal_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['phone'] = phone;
    data['fullname'] = fullname;
    data['created_at'] = createdAt;
    data['status'] = status;
    data['status_text'] = statusText;
    data['balance'] = balance;
    data['role'] = role;
    data['role_text'] = roleText;
    data['rating'] = rating;
    data['sms_live'] = smsLive;
    data['image'] = image;
    data['medal_id'] = medalId;
    data['medal_img'] = medalImg;
    return data;
  }
}
