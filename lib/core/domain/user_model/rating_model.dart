class RatingModel {
  int? subjectId;
  String? subjectText;
  List<Rating>? rating;

  RatingModel({this.subjectId, this.subjectText, this.rating});

  RatingModel.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    subjectText = json['subject_text'];
    if (json['rating'] != null) {
      rating = <Rating>[];
      json['rating'].forEach((v) {
        rating!.add(Rating.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subjectId;
    data['subject_text'] = subjectText;
    if (rating != null) {
      data['rating'] = rating!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rating {
  int? userId;
  String? userFullname;
  String? userTelegram;
  int? subjectId;
  String? subjectText;
  int? rating;
  int? ratingDay;
  int? ratingWeek;

  Rating(
      {this.userId,
      this.userFullname,
      this.userTelegram,
      this.subjectId,
      this.subjectText,
      this.rating,
      this.ratingDay,
      this.ratingWeek});

  Rating.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userFullname = json['user_fullname'];
    userTelegram = json['user_telegram'];
    subjectId = json['subject_id'];
    subjectText = json['subject_text'];
    rating = json['rating'];
    ratingDay = json['rating_day'];
    ratingWeek = json['rating_week'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_fullname'] = userFullname;
    data['user_telegram'] = userTelegram;
    data['subject_id'] = subjectId;
    data['subject_text'] = subjectText;
    data['rating'] = rating;
    data['rating_day'] = ratingDay;
    data['rating_week'] = ratingWeek;
    return data;
  }
}
