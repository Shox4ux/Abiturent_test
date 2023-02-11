import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/user_model/stat_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/user_repo.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsInitial()) {
    getStatsList();
  }

  final _repo = UserRepo();
  final _storage = AppStorage();

  void getStatsList() async {
    emit(OnStatsProgress());
    final userId = await _storage.getUserId();

    try {
      if (userId != null) {
        List<StatModel> dataList = [];
        final response = await _repo.getStats(userId);

        final rowData = response.data as List;

        final rowList = rowData.map((e) => StatModel.fromJson(e)).toList();

        if (rowList.isNotEmpty) {
          for (StatModel element in rowList) {
            if (element.subjectText != "(deleted)") {
              dataList.add(element);
            }
          }
          emit(OnStatsSuccess(dataList));
        } else {
          emit(const OnStatsError("Fanlarga bo`yicha obunalar mavjud emas..."));
        }
      }
    } on DioError catch (e) {
      emit(OnStatsError(e.response?.data["message"] ?? "Tizimda nosozlik"));
    } catch (e) {
      emit(const OnStatsError("Tizimda nosozlik"));
    }
  }
}
