import 'package:hive/hive.dart';
import 'package:test_app/core/helper/database/hive/news_hive/model/hive_news_model.dart';
import 'package:test_app/core/helper/database/hive/news_hive/news_hive_interface.dart';

class NewsHiveStorage extends NewsHiveInterface {
  final String _boxName = "news_date_box";

  @override
  Future<Box> openBox() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(NewsAdapter());
    }
    Box box = await Hive.openBox<NewsHiveModel>(_boxName);

    return box;
  }

  @override
  Future<void> saveNewsState(Box box, NewsHiveModel model) async {
    await box.put(model.newsId, model);
  }

  @override
  Future<void> deleteNewsState(Box box, NewsHiveModel model) async {
    await box.delete(model.newsId);
  }

  @override
  List<NewsHiveModel> getNewsStateList(Box box) {
    return box.values.toList() as List<NewsHiveModel>;
  }

  @override
  Future<void> clearNewsStateList(Box box) async {
    await box.clear();
  }

  @override
  Future<void> closeBox(Box box) async {
    await box.close();
  }

  @override
  Future<void> deleteBoxFromDisk(Box box) async {
    await box.deleteFromDisk();
  }
}
