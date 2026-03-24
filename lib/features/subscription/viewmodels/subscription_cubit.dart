import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/subscription_repository.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository repository;

  SubscriptionCubit(this.repository) : super(const SubscriptionState());

  Future<void> checkSubscriptionStatus(String courseId) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    try {
      final isSubscribed = await repository.isSubscribed(courseId);
      emit(state.copyWith(status: SubscriptionStatus.success, isSubscribed: isSubscribed));
    } catch (e) {
      emit(state.copyWith(status: SubscriptionStatus.error, message: e.toString()));
    }
  }

  Future<void> subscribe(String courseId) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    try {
      await repository.subscribeToCourse(courseId);
      emit(state.copyWith(status: SubscriptionStatus.success, isSubscribed: true));
    } catch (e) {
      emit(state.copyWith(status: SubscriptionStatus.error, message: e.toString()));
    }
  }
}
