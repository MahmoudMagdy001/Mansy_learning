import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutState {
  const LayoutState(this.currentIndex);
  final int currentIndex;
}

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutState(1));

  void changePage(int index) => emit(LayoutState(index));
}
