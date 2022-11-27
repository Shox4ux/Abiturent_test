class MainNewsModel {
  int? id;
  int? created;
  String? createdText;
  String? title;
  String? short;
  String? content;
  String? image;
  String? imageLink;
  String? video;

  MainNewsModel(
      {this.id,
      this.created,
      this.createdText,
      this.title,
      this.short,
      this.content,
      this.image,
      this.imageLink,
      this.video});

  MainNewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdText = json['created_text'];
    title = json['title'];
    short = json['short'];
    content = json['content'];
    image = json['image'];
    imageLink = json['image_link'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created'] = created;
    data['created_text'] = createdText;
    data['title'] = title;
    data['short'] = short;
    data['content'] = content;
    data['image'] = image;
    data['image_link'] = imageLink;
    data['video'] = video;
    return data;
  }
}
