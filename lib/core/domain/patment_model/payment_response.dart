class PaymentResponse {
  int? status;
  String? message;
  String? amount;
  String? cardPan;
  String? cardMonth;

  PaymentResponse(
      {this.status, this.message, this.amount, this.cardPan, this.cardMonth});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    amount = json['amount'];
    cardPan = json['card_pan'];
    cardMonth = json['card_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['amount'] = amount;
    data['card_pan'] = cardPan;
    data['card_month'] = cardMonth;
    return data;
  }
}