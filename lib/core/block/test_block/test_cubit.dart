import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/test_model/test_model.dart';
import 'package:test_app/core/helper/repos/test_repo.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial());
  final _repo = TestRepo();

  Future<void> getTestsBySubIdAndType(int subId, int typeIndex) async {
    emit(OnTestProgress());
    try {
      final response = await _repo.getTestsBySubjectId(subId, typeIndex);
      final allTestData = TestModel.fromJson(response.data);

      emit(OnTestSuccess(allTestData));
    } catch (e) {
      emit(OnTestError(e.toString()));
    }
  }


  Future<void> getTestById() async{
    emit()
  }
}
