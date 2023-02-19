import 'package:hive/hive.dart';
import 'package:test_app/core/helper/database/hive/news_hive/model/hive_news_model.dart';

abstract class NewsHiveInterface {
  Future<Box> openBox();
  List<NewsHiveModel> getNewsStateList(Box box);
  Future<void> saveNewsState(Box box, NewsHiveModel model);

  Future<void> deleteNewsState(Box box, NewsHiveModel model);
  Future<void> clearNewsStateList(Box box);
  Future<void> closeBox(Box box);
  Future<void> deleteBoxFromDisk(Box box);
}
