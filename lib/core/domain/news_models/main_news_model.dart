import 'package:equatable/equatable.dart';

class MainNewsModel extends Equatable {
  int id;
  int? created;
  String? createdText;
  String? title;
  String? short;
  String? content;
  int? alias;
  String? image;
  String? imageLink;

  MainNewsModel(
      {required this.id,
      this.created,
      this.createdText,
      this.title,
      this.short,
      this.content,
      this.alias,
      this.image,
      this.imageLink});

  factory MainNewsModel.fromJson(Map<String, dynamic> json) {
    return MainNewsModel(
      id: json['id'] as int,
      created: json['created'],
      createdText: json['created_text'],
      title: json['title'],
      short: json['short'],
      content: json['content'],
      alias: json['alias'],
      image: json['image'],
      imageLink: json['image_link'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created'] = created;
    data['created_text'] = createdText;
    data['title'] = title;
    data['short'] = short;
    data['content'] = content;
    data['alias'] = alias;
    data['image'] = image;
    data['image_link'] = imageLink;
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        created,
        createdText,
        title,
        short,
        content,
        alias,
        image,
        imageLink
      ];
}
