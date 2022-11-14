class SubjectModel {
  int? id;
  String? name;
  String? alias;
  int? price;
  int? updated;
  String? updatedDate;

  SubjectModel(
      {this.id,
      this.name,
      this.alias,
      this.price,
      this.updated,
      this.updatedDate});

  SubjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    price = json['price'];
    updated = json['updated'];
    updatedDate = json['updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['alias'] = alias;
    data['price'] = price;
    data['updated'] = updated;
    data['updated_date'] = updatedDate;
    return data;
  }
}
