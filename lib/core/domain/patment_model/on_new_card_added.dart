class OnNewCardAdded {
  Card? card;
  Phone? phone;

  OnNewCardAdded({this.card, this.phone});

  OnNewCardAdded.fromJson(Map<String, dynamic> json) {
    card = json['card'] != null ? Card.fromJson(json['card']) : null;
    phone = json['phone'] != null ? Phone.fromJson(json['phone']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (card != null) {
      data['card'] = card!.toJson();
    }
    if (phone != null) {
      data['phone'] = phone!.toJson();
    }
    return data;
  }
}

class Card {
  int? id;
  String? userId;
  String? cardPan;
  String? cardMonth;
  int? cardStatus;
  String? cardStatusText;
  String? cardName;

  Card(
      {this.id,
      this.userId,
      this.cardPan,
      this.cardMonth,
      this.cardStatus,
      this.cardStatusText,
      this.cardName});

  Card.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    cardPan = json['card_pan'];
    cardMonth = json['card_month'];
    cardStatus = json['card_status'];
    cardStatusText = json['card_status_text'];
    cardName = json['card_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['card_pan'] = cardPan;
    data['card_month'] = cardMonth;
    data['card_status'] = cardStatus;
    data['card_status_text'] = cardStatusText;
    data['card_name'] = cardName;
    return data;
  }
}

class Phone {
  bool? sent;
  String? phone;
  int? wait;

  Phone({this.sent, this.phone, this.wait});

  Phone.fromJson(Map<String, dynamic> json) {
    sent = json['sent'];
    phone = json['phone'];
    wait = json['wait'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sent'] = sent;
    data['phone'] = phone;
    data['wait'] = wait;
    return data;
  }
}
