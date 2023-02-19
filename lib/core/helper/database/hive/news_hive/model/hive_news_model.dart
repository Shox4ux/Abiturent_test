import 'package:hive/hive.dart';

class NewsHiveModel {
  final int newsId;
  final bool isNew;

  NewsHiveModel({required this.newsId, required this.isNew});
}

class NewsAdapter extends TypeAdapter<NewsHiveModel> {
  @override
  NewsHiveModel read(BinaryReader reader) {
    final newsId = reader.readInt();
    final isNew = reader.readBool();
    return NewsHiveModel(newsId: newsId, isNew: isNew);
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, NewsHiveModel obj) {
    writer.writeInt(obj.newsId);
    writer.writeBool(obj.isNew);
  }
}

// class BookAdapter extends TypeAdapter<HiveBookModel> {
//   @override
//   HiveBookModel read(BinaryReader reader) {
//     final id = reader.readInt();
//     final path = reader.readString();
//     return HiveBookModel(id: id, path: path);
//   }

//   @override
//   int get typeId => 0;

//   @override
//   void write(BinaryWriter writer, HiveBookModel obj) {
//     writer.writeInt(obj.id);
//     writer.writeString(obj.path);
//   }
// }