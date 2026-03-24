enum SubscriptionStatus { initial, loading, success, error }

class SubscriptionState {
  final SubscriptionStatus status;
  final String? message;
  final bool isSubscribed;

  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.message,
    this.isSubscribed = false,
  });

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    String? message,
    bool? isSubscribed,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      message: message ?? this.message,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }
}
