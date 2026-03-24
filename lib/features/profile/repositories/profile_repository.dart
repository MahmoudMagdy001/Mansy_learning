import '../models/profile_model.dart';
import '../services/profile_service.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
  Future<void> updateProfile(ProfileModel profile);
  Future<void> updatePassword(String currentPassword, String newPassword);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService service;

  ProfileRepositoryImpl(this.service);

  @override
  Future<ProfileModel> getProfile() async {
    return await service.getProfile();
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    return await service.updateProfile(profile);
  }

  @override
  Future<void> updatePassword(String currentPassword, String newPassword) async {
    return await service.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
