import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:test_app/core/helper/database/hive/logic/hive_storage.dart';
import 'package:test_app/core/helper/database/hive/model/hive_book_model.dart';
import 'package:test_app/core/helper/dio/dio_client.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  BookCubit() : super(BookInitial());
  final _dio = DioClient.getDio();
  final _hiveStorage = HiveStorage();

  Future<void> downloadFile(String url, String fileName, int bookId) async {
    final tempDir = await pathProvider.getTemporaryDirectory();
    final filePath = "${tempDir.path}/$fileName";

    try {
      if (await isBookDownloaded(bookId)) {
        await _openFile(bookId);
      } else {
        await _downloadAndSave(url, filePath);
        await _saveBookInHiveStorage(filePath, bookId);
      }
    } on DioError catch (e) {
      emit(OnError(e.response!.data["message"]));
    } on SocketException {
      emit(const OnError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnError("Tizimda nosozlik"));
    }
  }

  Future<void> _downloadAndSave(String url, String filePath) async {
    await _dio.download(
      url,
      filePath,
      onReceiveProgress: (count, total) {
        var progress = ((count / total)).toDouble();
        emit(OnProgress(progress));
        if (count == total) {
          emit(OnDownloadCompleted());
        }
      },
    );
  }

  Future<void> _openFile(int bookId) async {
    final box = await _hiveStorage.openBox();
    final list = _hiveStorage.getBookList(box);
    for (var element in list) {
      if (element.id == bookId) {
        print(element.id);
        print(element.path);

        await OpenFile.open(element.path);
        await _hiveStorage.closeBox(box);
      } else {
        emit(const OnError("Qaytatan urunib ko'ring"));
      }
    }
  }

  Future<bool> isBookDownloaded(int bookId) async {
    final box = await _hiveStorage.openBox();
    final list = _hiveStorage.getBookList(box);
    for (var element in list) {
      if (element.id == bookId) {
        await _hiveStorage.closeBox(box);
        return true;
      } else {
        await _hiveStorage.closeBox(box);
        return false;
      }
    }
    return false;
  }

  Future<void> _saveBookInHiveStorage(String filePath, int bookId) async {
    final box = await _hiveStorage.openBox();
    await _hiveStorage.saveBook(box, HiveBookModel(id: bookId, path: filePath));
    await _openFile(bookId);
  }
}
