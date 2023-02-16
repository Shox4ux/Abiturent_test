import 'package:hive/hive.dart';
import 'package:test_app/core/helper/database/hive/news_hive/news_hive_interface.dart';

class NewsHiveStorage extends NewsHiveInterface {
  final String _boxName = "news_date_box";
  @override
  Future<Box> openBox() async {
    Box box = await Hive.openBox<String>(_boxName);

    return box;
  }

  @override
  Future<void> saveDate(Box box, String createdDate, int newsId) async {
    await box.put(newsId, createdDate);
  }

  @override
  Future<void> removeDate(Box box, int newsId) async {
    await box.delete(newsId);
  }

  @override
  List<String> getDateList(Box box) {
    return box.values.toList() as List<String>;
  }

  @override
  Future<void> clearDateList(Box box) async {
    await box.clear();
  }

  @override
  Future<void> closeBox(Box box) async {
    await box.close();
  }
}
