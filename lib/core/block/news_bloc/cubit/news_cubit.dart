import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/news_models/main_news_model.dart';
import 'package:test_app/core/helper/repos/news_repo.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());
  final _repo = NewsRepository();

  Future<void> fetchNewsData() async {
    try {
      final response = await _repo.getMainNews();
      final rowData = response.data as List;
      print(rowData);
      final newsList = rowData
          .map(
            (e) => MainNewsModel.fromJson(e),
          )
          .toList();

      emit(OnSuccess(list: newsList));
    } catch (e) {
      emit(
        OnError(
          errorMessage: e.toString(),
        ),
      );
      print(e);
    }
  }
}
