class CardModel {
  int? id;
  int? userId;
  String? cardToken;
  String? cardPan;
  String? cardMonth;
  int? cardStatus;

  CardModel(
      {this.id,
      this.userId,
      this.cardToken,
      this.cardPan,
      this.cardMonth,
      this.cardStatus});

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    cardToken = json['card_token'];
    cardPan = json['card_pan'];
    cardMonth = json['card_month'];
    cardStatus = json['card_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['card_token'] = cardToken;
    data['card_pan'] = cardPan;
    data['card_month'] = cardMonth;
    data['card_status'] = cardStatus;
    return data;
  }
}
