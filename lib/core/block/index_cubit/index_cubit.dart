import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/block/drawer_cubit/drawer_cubit.dart';
import 'package:test_app/core/helper/database/app_storage.dart';

part 'index_state.dart';

class IndexCubit extends Cubit<int?> {
  IndexCubit() : super(0);

  final _storage = AppStorage();

  final _c = DrawerCubit();

  void setUp(int index) async {
    // await _storage.saveDrawerIndex(index);
    // int? i = await _storage.getDrawerIndex();
    emit(index);
  }

  void checkDrawerIndex() async {
    int? i = await _storage.getDrawerIndex();
    emit(i);
  }
}
