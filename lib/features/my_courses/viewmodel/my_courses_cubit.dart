import 'package:flutter_bloc/flutter_bloc.dart';
import 'my_courses_state.dart';
import '../repository/my_courses_repository.dart';

class MyCoursesCubit extends Cubit<MyCoursesState> {
  MyCoursesCubit(this.repository) : super(const MyCoursesState());
  final MyCoursesRepository repository;

  Future<void> getMyCourses() async {
    emit(state.copyWith(status: MyCoursesStatus.loading));
    try {
      final courses = await repository.getMyCourses();
      emit(state.copyWith(status: MyCoursesStatus.success, courses: courses));
    } catch (e) {
      emit(
        state.copyWith(status: MyCoursesStatus.error, message: e.toString()),
      );
    }
  }
}
