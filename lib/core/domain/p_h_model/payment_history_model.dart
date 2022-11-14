class PaymentHistory {
  int? id;
  int? type;
  String? typeText;
  int? created;
  String? createdDate;
  String? content;
  int? userId;
  int? cardId;
  int? amount;
  int? transactionId;

  PaymentHistory(
      {this.id,
      this.type,
      this.typeText,
      this.created,
      this.createdDate,
      this.content,
      this.userId,
      this.cardId,
      this.amount,
      this.transactionId});

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    typeText = json['type_text'];
    created = json['created'];
    createdDate = json['created_date'];
    content = json['content'];
    userId = json['user_id'];
    cardId = json['card_id'];
    amount = json['amount'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['type_text'] = typeText;
    data['created'] = created;
    data['created_date'] = createdDate;
    data['content'] = content;
    data['user_id'] = userId;
    data['card_id'] = cardId;
    data['amount'] = amount;
    data['transaction_id'] = transactionId;
    return data;
  }
}
