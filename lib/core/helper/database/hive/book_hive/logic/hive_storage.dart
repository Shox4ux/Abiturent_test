import 'package:hive/hive.dart';
import 'package:test_app/core/helper/database/hive/book_hive/logic/hive_interface.dart';
import 'package:test_app/core/helper/database/hive/book_hive/model/hive_book_model.dart';

class HiveStorage extends HiveInterfaceStorage {
  String boxName = "bookBox";
  @override
  Future<Box> openBox() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BookAdapter());
    }
    Box box = await Hive.openBox<HiveBookModel>(boxName);
    return box;
  }

  @override
  Future<void> saveBook(Box box, HiveBookModel bookModel) async {
    await box.put(bookModel.id, bookModel);
  }

  @override
  List<HiveBookModel> getBookList(Box box) {
    return box.values.toList() as List<HiveBookModel>;
  }

  @override
  Future<void> removeBook(Box box, HiveBookModel bookModel) async {
    await box.delete(bookModel.id);
  }

  @override
  Future<void> clearBookList(Box box) async {
    await box.clear();
  }

  @override
  Future<void> closeBox(Box box) async {
    box.close();
  }
}
