import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/subject_models/subject_model.dart';

part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  SubjectCubit() : super(SubjectInitial());

  int getSubId(int subId) {
    print("from test cubit id:$subId");
    return subId;
  }
}
