import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_app/core/helper/dio/dio_client.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  BookCubit() : super(BookInitial());

  final _dio = DioClient.getDio();

  Future<void> downloadFile(String url, String fileName) async {
    try {
      await _dio.download(
        url,
        await _getPath(fileName),
        onReceiveProgress: (count, total) {
          var progress = ((count / total)).toDouble();
          print(progress);
          emit(OnProgress(progress));

          // print("from download: $count $total");
          if (count == total) {
            emit(OnDownloadCompleted());
          }
        },
      );
    } on DioError catch (e) {
      emit(OnError(e.response!.data["message"]));
    } on SocketException {
      emit(const OnError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnError("Tizimda nosozlik"));
    }
  }
}

Future<String> _getPath(String fileName) async {
  final dir = await getApplicationDocumentsDirectory();
  var file = File("${dir.path}/$fileName");

  // _writeFile(file);

  return "${dir.path}/$fileName";
}

// void _writeFile(File file) {
//   final raf = file.openSync(mode: FileMode.write);
//   raf.writeFromSync()
// }
