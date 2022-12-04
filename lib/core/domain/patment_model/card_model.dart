class CardModel {
  int? id;
  int? userId;
  String? cardPan;
  String? cardMonth;
  int? cardStatus;
  String? cardName;

  CardModel(
      {this.id,
      this.userId,
      this.cardPan,
      this.cardMonth,
      this.cardStatus,
      this.cardName});

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    cardPan = json['card_pan'];
    cardMonth = json['card_month'];
    cardStatus = json['card_status'];
    cardName = json['card_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['card_pan'] = cardPan;
    data['card_month'] = cardMonth;
    data['card_status'] = cardStatus;
    data['card_name'] = cardName;
    return data;
  }
}
