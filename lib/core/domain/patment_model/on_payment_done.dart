class OnPaymentDone {
  String? message;
  Receipt? receipt;

  OnPaymentDone({this.message, this.receipt});

  OnPaymentDone.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    receipt =
        json['receipt'] != null ? Receipt.fromJson(json['receipt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (receipt != null) {
      data['receipt'] = receipt!.toJson();
    }
    return data;
  }
}

class Receipt {
  String? sId;
  int? createTime;
  int? payTime;
  int? cancelTime;
  int? state;
  int? type;
  bool? external;
  int? operation;
  dynamic category;
  dynamic error;
  String? description;
  Detail? detail;
  int? amount;
  int? currency;
  int? commission;
  List<Account>? account;
  Card? card;
  Payer? payer;
  // Merchant? merchant;
  // Meta? meta;
  // int? processingId;

  Receipt({
    this.sId,
    this.createTime,
    this.payTime,
    this.cancelTime,
    this.state,
    this.type,
    this.external,
    this.operation,
    this.category,
    this.error,
    this.description,
    this.detail,
    this.amount,
    this.currency,
    this.commission,
    this.account,
    this.card,
    this.payer,
    // this.merchant,
    // this.meta,
    // this.processingId
  });

  Receipt.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createTime = json['create_time'];
    payTime = json['pay_time'];
    cancelTime = json['cancel_time'];
    state = json['state'];
    type = json['type'];
    external = json['external'];
    operation = json['operation'];
    category = json['category'];
    error = json['error'];
    description = json['description'];
    detail = json['detail'] != null ? Detail.fromJson(json['detail']) : null;
    amount = json['amount'];
    currency = json['currency'];
    commission = json['commission'];
    if (json['account'] != null) {
      account = <Account>[];
      json['account'].forEach((v) {
        account!.add(Account.fromJson(v));
      });
    }
    card = json['card'] != null ? Card.fromJson(json['card']) : null;
    payer = json['payer'] != null ? Payer.fromJson(json['payer']) : null;
    // merchant =
    //     json['merchant'] != null ? Merchant.fromJson(json['merchant']) : null;
    // meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    // processingId = json['processing_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['create_time'] = createTime;
    data['pay_time'] = payTime;
    data['cancel_time'] = cancelTime;
    data['state'] = state;
    data['type'] = type;
    data['external'] = external;
    data['operation'] = operation;
    data['category'] = category;
    data['error'] = error;
    data['description'] = description;
    if (detail != null) {
      data['detail'] = detail!.toJson();
    }
    data['amount'] = amount;
    data['currency'] = currency;
    data['commission'] = commission;
    if (account != null) {
      data['account'] = account!.map((v) => v.toJson()).toList();
    }
    if (card != null) {
      data['card'] = card!.toJson();
    }
    if (payer != null) {
      data['payer'] = payer!.toJson();
    }
    // if (merchant != null) {
    //   data['merchant'] = merchant!.toJson();
    // }
    // if (meta != null) {
    //   data['meta'] = meta!.toJson();
    // }
    // data['processing_id'] = processingId;
    return data;
  }
}

class Detail {
  dynamic discount;
  dynamic shipping;
  List<Items>? items;

  Detail({this.discount, this.shipping, this.items});

  Detail.fromJson(Map<String, dynamic> json) {
    discount = json['discount'];
    shipping = json['shipping'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discount'] = discount;
    data['shipping'] = shipping;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? title;
  int? price;
  int? count;
  String? code;
  int? vatPercent;
  String? packageCode;

  Items(
      {this.title,
      this.price,
      this.count,
      this.code,
      this.vatPercent,
      this.packageCode});

  Items.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    count = json['count'];
    code = json['code'];
    vatPercent = json['vat_percent'];
    packageCode = json['package_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['price'] = price;
    data['count'] = count;
    data['code'] = code;
    data['vat_percent'] = vatPercent;
    data['package_code'] = packageCode;
    return data;
  }
}

class Account {
  String? name;
  String? title;
  String? value;
  bool? main;

  Account({this.name, this.title, this.value, this.main});

  Account.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    value = json['value'];
    main = json['main'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['title'] = title;
    data['value'] = value;
    data['main'] = main;
    return data;
  }
}

class Card {
  String? number;
  String? expire;

  Card({this.number, this.expire});

  Card.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    expire = json['expire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['expire'] = expire;
    return data;
  }
}

class Payer {
  String? phone;

  Payer({this.phone});

  Payer.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    return data;
  }
}

class Merchant {
  String? sId;
  String? name;
  String? organization;
  String? address;
  String? businessId;
  Epos? epos;
  int? date;
  dynamic logo;
  String? type;
  dynamic terms;

  Merchant(
      {this.sId,
      this.name,
      this.organization,
      this.address,
      this.businessId,
      this.epos,
      this.date,
      this.logo,
      this.type,
      this.terms});

  Merchant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    organization = json['organization'];
    address = json['address'];
    businessId = json['business_id'];
    epos = json['epos'] != null ? Epos.fromJson(json['epos']) : null;
    date = json['date'];
    logo = json['logo'];
    type = json['type'];
    terms = json['terms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['organization'] = organization;
    data['address'] = address;
    data['business_id'] = businessId;
    if (epos != null) {
      data['epos'] = epos!.toJson();
    }
    data['date'] = date;
    data['logo'] = logo;
    data['type'] = type;
    data['terms'] = terms;
    return data;
  }
}

class Epos {
  String? merchantId;
  String? terminalId;

  Epos({this.merchantId, this.terminalId});

  Epos.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    terminalId = json['terminalId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['terminalId'] = terminalId;
    return data;
  }
}

class Meta {
  String? source;
  String? owner;

  Meta({this.source, this.owner});

  Meta.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    owner = json['owner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source'] = source;
    data['owner'] = owner;
    return data;
  }
}
