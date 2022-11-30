import 'package:hive/hive.dart';

class HiveBookModel {
  final int id;
  final String path;

  HiveBookModel({
    required this.id,
    required this.path,
  });
}

class BookAdapter extends TypeAdapter<HiveBookModel> {
  @override
  HiveBookModel read(BinaryReader reader) {
    final id = reader.readInt();
    final path = reader.readString();
    return HiveBookModel(id: id, path: path);
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, HiveBookModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.path);
  }
}
