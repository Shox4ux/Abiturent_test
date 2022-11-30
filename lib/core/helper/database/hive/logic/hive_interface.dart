import 'package:hive/hive.dart';
import 'package:test_app/core/helper/database/hive/model/hive_book_model.dart';

abstract class HiveInterfaceStorage {
  Future<Box> openBox();
  List<HiveBookModel> getBookList(Box box);
  Future<void> saveBook(Box box, HiveBookModel bookModel);
  Future<void> removeBook(Box box, HiveBookModel bookModel);
  Future<void> clearBookList(Box box);
  Future<void> closeBox(Box box);
}
