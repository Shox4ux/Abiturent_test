import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/helper/repos/user_repo.dart';
import '../../domain/user_model/common_rating.dart';
import '../../domain/user_model/rating_model.dart';
part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit() : super(RatingInitial());
  final _repo = UserRepo();

  Future<void> callUserRating(int subjectId) async {
    emit(OnRatingProgress());
    try {
      final response = await _repo.getUsersRatings(subjectId);
      final rowData = RatingModel.fromJson(response.data);
      if (rowData.rating!.isEmpty) {
        emit(OnRatingEmpty(rowData));
        return;
      }
      emit(OnRatingReceived(rowData));
    } on DioError catch (e) {
      emit(OnRatingError(error: e.response!.data["message"]));
    } on SocketException {
      emit(const OnRatingError(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnRatingError(error: "Tizimda nosozlik"));
    }
  }
}
