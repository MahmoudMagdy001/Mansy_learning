enum EditProfileStatus { initial, loading, success, error }

class EditProfileState {
  final EditProfileStatus status;
  final String? message;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.message,
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    String? message,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
