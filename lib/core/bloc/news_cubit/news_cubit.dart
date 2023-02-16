import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/news_models/main_news_model.dart';
import 'package:test_app/core/domain/news_models/news_model_notification.dart';
import 'package:test_app/core/helper/database/hive/news_hive/news_hive_storage.dart';
import 'package:test_app/core/helper/repos/news_repo.dart';
part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());
  final _newsRepo = NewsRepository();
  final _newsHiveStorage = NewsHiveStorage();

  void getAllNews() async {
    try {
      ////
      final response = await _newsRepo.getAllNews();
      final rowList = response.data as List;
      final rowData = rowList.map((e) => MainNewsModel.fromJson(e)).toList();
      ////
      final storageResponse = await _getAllNewsCreatedDates();

      _crudDecider(rowData, storageResponse);
    } on DioError catch (e) {
      emit(OnNewsError(message: e.response?.data ?? "tizimda nosozlik"));
    } catch (e) {
      emit(OnNewsError(message: e.toString()));
    }
  }

  void getNewsWithPagination() async {
    try {
      final response =
          await _newsRepo.getNewsWithPagination(page: 1, perPage: 10);
      final rowList = response.data as List;
      final rowData = rowList.map((e) => MainNewsModel.fromJson(e)).toList();
      ////
      final storageResponse = await _getAllNewsCreatedDates();

      _crudDecider(rowData, storageResponse);
    } on DioError catch (e) {
      emit(OnNewsError(message: e.response?.data ?? "tizimda nosozlik"));
    } catch (e) {
      emit(OnNewsError(message: e.toString()));
    }
  }

  void getNewsById(int newsId) async {
    try {
      final response = await _newsRepo.getNewsById(newsId: newsId);
      final rowData = MainNewsModel.fromJson(response.data);
      emit(OnInnerNewsReceived(model: rowData));
    } on DioError catch (e) {
      emit(OnNewsError(message: e.response?.data ?? "tizimda nosozlik"));
    } catch (e) {
      emit(OnNewsError(message: e.toString()));
    }
  }

  void _crudDecider(List<MainNewsModel> newsList, List<String> dateList) {
    if (newsList.isEmpty) {
      emit(const OnNewsError(message: "Hozircha yangiliklar mavjud emas"));
    } else {
      if (dateList.isEmpty) {
        Set<NewsWithNotificationModel> dataList = {};

        for (MainNewsModel element in newsList) {
          dataList.add(NewsWithNotificationModel(model: element, isNew: true));
        }
        emit(OnNewsReceived(newsList: dataList.toList(), shouldNotify: true));
        _saveNewsCreatedDateList(newsList);
      }

      if (dateList.isNotEmpty) {
        bool shouldnotify = false;
        Set<NewsWithNotificationModel> dataList = {};

        for (MainNewsModel element in newsList) {
          if (dateList.contains(element.createdText)) {
            shouldnotify = false;
            dataList.add(
                NewsWithNotificationModel(model: element, isNew: shouldnotify));
          } else {
            shouldnotify = true;
            dataList.add(
                NewsWithNotificationModel(model: element, isNew: shouldnotify));
            _saveNewsCreatedDate(element.createdText!, element.id!);
          }
        }

        emit(OnNewsReceived(
            newsList: dataList.toList(), shouldNotify: shouldnotify));
      }
    }
  }

  Future<List<String>> _getAllNewsCreatedDates() async {
    final box = await _newsHiveStorage.openBox();
    final dataList = _newsHiveStorage.getDateList(box);
    return dataList;
  }

  void _saveNewsCreatedDateList(List<MainNewsModel> newsList) async {
    final box = await _newsHiveStorage.openBox();

    for (MainNewsModel element in newsList) {
      await _newsHiveStorage.saveDate(box, element.createdText!, element.id!);
    }
  }

  void _saveNewsCreatedDate(String createdText, int id) async {
    final box = await _newsHiveStorage.openBox();

    await _newsHiveStorage.saveDate(box, createdText, id);
  }

  void _removeCreatedDate(int newsId) async {
    final box = await _newsHiveStorage.openBox();
    await _newsHiveStorage.removeDate(box, newsId);
  }
}
