import '../services/subscription_service.dart';

abstract class SubscriptionRepository {
  Future<void> subscribeToCourse(String courseId);
  Future<bool> isSubscribed(String courseId);
}

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionService service;

  SubscriptionRepositoryImpl(this.service);

  @override
  Future<void> subscribeToCourse(String courseId) =>
      service.subscribeToCourse(courseId);

  @override
  Future<bool> isSubscribed(String courseId) =>
      service.isSubscribed(courseId);
}
