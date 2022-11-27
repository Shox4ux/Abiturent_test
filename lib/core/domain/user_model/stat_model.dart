class StatModel {
  int? userId;
  String? userFullname;
  int? subjectId;
  String? subjectText;
  int? rating;
  int? ratingDay;
  int? ratingWeek;
  String? medalName;
  String? medalImg;

  StatModel(
      {this.userId,
      this.userFullname,
      this.subjectId,
      this.subjectText,
      this.rating,
      this.ratingDay,
      this.ratingWeek,
      this.medalName,
      this.medalImg});

  StatModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userFullname = json['user_fullname'];
    subjectId = json['subject_id'];
    subjectText = json['subject_text'];
    rating = json['rating'];
    ratingDay = json['rating_day'];
    ratingWeek = json['rating_week'];
    medalName = json['medal_name'];
    medalImg = json['medal_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_fullname'] = userFullname;
    data['subject_id'] = subjectId;
    data['subject_text'] = subjectText;
    data['rating'] = rating;
    data['rating_day'] = ratingDay;
    data['rating_week'] = ratingWeek;
    data['medal_name'] = medalName;
    data['medal_img'] = medalImg;
    return data;
  }
}
