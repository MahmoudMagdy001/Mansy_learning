import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import '../repository/home_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.repository) : super(const HomeState());
  final HomeRepository repository;

  Future<void> getCourses() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final courses = await repository.getCourses();
      emit(state.copyWith(status: HomeStatus.success, courses: courses));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, message: e.toString()));
    }
  }
}
