import 'package:hive/hive.dart';

abstract class NewsHiveInterface {
  Future<Box> openBox();
  List<String> getDateList(Box box);
  Future<void> saveDate(Box box, String createdDate, int newsId);
  Future<void> removeDate(Box box, int newsId);
  Future<void> clearDateList(Box box);
  Future<void> closeBox(Box box);
}
