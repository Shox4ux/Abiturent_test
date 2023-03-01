import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/news_models/main_news_model.dart';
import 'package:test_app/core/domain/news_models/news_model_notification.dart';
import 'package:test_app/core/helper/database/hive/news_hive/model/hive_news_model.dart';
import 'package:test_app/core/helper/database/hive/news_hive/news_hive_storage.dart';
import 'package:test_app/core/helper/repos/news_repo.dart';
part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial()) {
    getAllNews();
  }
  final _newsRepo = NewsRepository();
  final _newsHiveStorage = NewsHiveStorage();
  bool shouldNotifyProfile = false;

  Set<NewsWithNotificationModel> setListToShow = {};

  void getAllNews() async {
    try {
      // deleteBoxFromDisk();

      // print("formatted");
      //-------get all data from storage and network-----//
      final response = await _newsRepo.getAllNews();
      final rowList = response.data as List;
      final newsList = rowList.map((e) => MainNewsModel.fromJson(e)).toList();
      final storageResponse = await _getAllNewsCreatedDates();

      //---------------check is there any new news-------//
      _compareNetworkAndStorageData(newsList, storageResponse);

      //----------------Trouble shooting------------------//
    } on DioError catch (e) {
      emit(OnNewsError(message: e.response?.data ?? "tizimda nosozlik"));
    } catch (e) {
      emit(OnNewsError(message: e.toString()));
    }
  }

  void _compareNetworkAndStorageData(
    List<MainNewsModel> networkList,
    List<NewsHiveModel> storageList,
  ) async {
    if (networkList.isEmpty) {
      emit(const OnNewsError(message: "Hozircha yangiliklar mavjud emas"));
    } else {
      if (storageList.isEmpty) {
        _onStorageEmpty(networkList);
      }

      if (storageList.isNotEmpty && networkList.isNotEmpty) {
        _onStorageIsNotEmpty(networkList, storageList);
        // shouldNotifyProfile = false;
      }
    }
  }

  void _onStorageEmpty(List<MainNewsModel> networkList) {
    shouldNotifyProfile = true;
    setListToShow.clear();

    for (MainNewsModel element in networkList) {
      final m = NewsHiveModel(isNew: true, newsId: element.id!);
      _saveNewDataIntoStorage(model: m);

      setListToShow.add(NewsWithNotificationModel(model: element, isNew: true));
    }

    emit(OnNewsReceived(
      newsList: setListToShow.toList(),
      shouldNotifyProfile: shouldNotifyProfile,
    ));
  }

  void _onStorageIsNotEmpty(
    List<MainNewsModel> networkList,
    List<NewsHiveModel> storageList,
  ) async {
    //-------prepare to begin operation------------\\
    setListToShow.clear();
    List<NewsWithNotificationModel> newData = [];
    List<NewsWithNotificationModel> oldData = [];

    for (MainNewsModel element in networkList) {
      newData.add(NewsWithNotificationModel(model: element, isNew: true));
    }

    //-----------------filtering old and new data-----------------------\\
    for (int i = 0; i < networkList.length; i++) {
      for (int j = 0; j < storageList.length; j++) {
        if (networkList[i].id == storageList[j].newsId) {
          oldData.add(
              NewsWithNotificationModel(model: networkList[i], isNew: false));
          newData.removeWhere(
              (element) => element.model.id == storageList[j].newsId);
        }
      }
    }
    //-----------------adding old and new data-----------------------\\
    setListToShow.addAll(newData);
    setListToShow.addAll(oldData);
    if (newData.isNotEmpty) {
      shouldNotifyProfile = true;
    } else {
      shouldNotifyProfile = false;
    }
    //---------------------storing new data into storage-----------\\
    for (NewsWithNotificationModel element in newData) {
      final m = NewsHiveModel(newsId: element.model.id!, isNew: false);
      _updateStorageData(model: m);
    }

    emit(OnNewsReceived(
      newsList: setListToShow.toList(),
      shouldNotifyProfile: shouldNotifyProfile,
    ));
  }

  void markAllNewsAsRead({
    required List<NewsWithNotificationModel> showcaseList,
  }) {
    emit(OnNewsProgress());
    shouldNotifyProfile = false;
    setListToShow.clear();
    for (var element in showcaseList) {
      setListToShow.add(
        NewsWithNotificationModel(model: element.model, isNew: false),
      );
    }

    emit(OnNewsReceived(
      newsList: setListToShow.toList(),
      shouldNotifyProfile: shouldNotifyProfile,
    ));
  }

  void markOneNewsAsRead({
    required List<NewsWithNotificationModel> showcaseList,
    required NewsWithNotificationModel model,
  }) {
    emit(OnNewsProgress());

    setListToShow.clear();
    for (var element in showcaseList) {
      if (element.model.id == model.model.id) {
        setListToShow
            .add(NewsWithNotificationModel(model: element.model, isNew: false));
      } else {
        setListToShow.add(element);
      }
    }

    _checkIsAllDataIsOld();
  }

  void _checkIsAllDataIsOld() {
    for (var element in setListToShow) {
      if (element.isNew == false) {
        shouldNotifyProfile = false;
      } else {
        shouldNotifyProfile = true;
      }
    }
    emit(OnNewsReceived(
      newsList: setListToShow.toList(),
      shouldNotifyProfile: shouldNotifyProfile,
    ));
  }

//-----------Storage functions----------------------------//
  void _saveNewDataIntoStorage({required NewsHiveModel model}) async {
    final box = await _newsHiveStorage.openBox();
    await _newsHiveStorage.saveNewsState(box, model);
  }

  void _updateStorageData({required NewsHiveModel model}) async {
    final box = await _newsHiveStorage.openBox();
    await _newsHiveStorage.saveNewsState(box, model);
  }

  void getNewsWithPagination() async {
    try {
      final response =
          await _newsRepo.getNewsWithPagination(page: 1, perPage: 10);
      final rowList = response.data as List;
      final rowData = rowList.map((e) => MainNewsModel.fromJson(e)).toList();
      ////
      final storageResponse = await _getAllNewsCreatedDates();

      _compareNetworkAndStorageData(rowData, storageResponse);
    } on DioError catch (e) {
      emit(OnNewsError(message: e.response?.data ?? "tizimda nosozlik"));
    } catch (e) {
      emit(OnNewsError(message: e.toString()));
    }
  }

  Future<void> clearBox() async {
    final box = await _newsHiveStorage.openBox();
    await _newsHiveStorage.clearNewsStateList(box);
  }

  void deleteBoxFromDisk() async {
    final box = await _newsHiveStorage.openBox();
    _newsHiveStorage.deleteBoxFromDisk(box);
  }

  Future<List<NewsHiveModel>> _getAllNewsCreatedDates() async {
    final box = await _newsHiveStorage.openBox();
    final dataList = _newsHiveStorage.getNewsStateList(box);
    return dataList;
  }
}
