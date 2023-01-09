import 'card_list_model.dart';

class CardModel {
  CardListModel? card;
  Phone? phone;

  CardModel({this.card, this.phone});

  CardModel.fromJson(Map<String, dynamic> json) {
    card = json['card'] != null ? CardListModel.fromJson(json['card']) : null;
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
