import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(DrawerInitial());

  int? testType;

  void saveSubId(int id) {
    emit(DrawerSubId(id));
    print("from cubit $id");
  }

  int getDrawerIndex() => (state as DrawerSubId).subId;
}
