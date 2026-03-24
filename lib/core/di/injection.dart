import 'package:get_it/get_it.dart';
import '../../features/profile/repositories/profile_repository.dart';
import '../../features/profile/services/profile_service.dart';
import '../../features/profile/viewmodels/change_password_cubit.dart';
import '../../features/profile/viewmodels/edit_profile_cubit.dart';
import '../../features/profile/viewmodels/profile_cubit.dart';
import '../../features/contact_us/services/contact_us_service.dart';
import '../../features/contact_us/repositories/contact_us_repository.dart';
import '../../features/contact_us/viewmodels/contact_us_cubit.dart';
import '../../features/terms_and_conditions/repositories/terms_repository.dart';
import '../../features/terms_and_conditions/viewmodels/terms_cubit.dart';
import '../../features/my_courses/service/my_courses_service.dart';
import '../../features/my_courses/repository/my_courses_repository.dart';
import '../../features/my_courses/repository/my_courses_repository_impl.dart';
import '../../features/my_courses/viewmodel/my_courses_cubit.dart';
import '../../features/subscription/services/subscription_service.dart';
import '../../features/subscription/repositories/subscription_repository.dart';
import '../../features/subscription/viewmodels/subscription_cubit.dart';
import '../../features/course/services/course_service.dart';
import '../../features/course/repositories/course_repository.dart';
import '../../features/course/repositories/course_repository_impl.dart';
import '../../features/course/services/content_service.dart';
import '../../features/course/repositories/content_repository.dart';
import '../../features/course/viewmodels/course_cubit.dart';
import '../../features/home/service/home_service.dart';
import '../../features/home/repository/home_repository.dart';
import '../../features/home/repository/home_repository_impl.dart';
import '../../features/home/viewmodel/home_cubit.dart';
import '../../features/signup/services/signup_service.dart';
import '../../features/signup/repositories/signup_repository.dart';
import '../../features/signup/repositories/signup_repository_impl.dart';
import '../../features/signup/viewmodels/signup_cubit.dart';
import '../../features/login/service/login_service.dart';
import '../../features/login/repository/login_repository.dart';
import '../../features/login/repository/login_repository_impl.dart';
import '../../features/login/viewmodel/login_cubit.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Services
  getIt.registerLazySingleton<ProfileService>(() => ProfileService());
  getIt.registerLazySingleton<ContactUsService>(() => ContactUsService());
  getIt.registerLazySingleton<CourseService>(() => CourseService());
  getIt.registerLazySingleton<ContentService>(() => ContentService());
  getIt.registerLazySingleton<HomeService>(() => HomeService());
  getIt.registerLazySingleton<SignupService>(() => SignupService());
  getIt.registerLazySingleton<LoginService>(() => LoginService());

  // Repositories
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileService>()),
  );
  getIt.registerLazySingleton<ContactUsRepository>(
    () => ContactUsRepositoryImpl(),
  );
  getIt.registerLazySingleton<TermsRepository>(
    () => TermsRepositoryImpl(),
  );
  getIt.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(getIt<CourseService>(), getIt<ContentService>()),
  );
  getIt.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(getIt<ContentService>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeService>()),
  );
  getIt.registerLazySingleton<SignupRepository>(
    () => SignupRepositoryImpl(getIt<SignupService>()),
  );
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(getIt<LoginService>()),
  );

  // ViewModels (Cubits)
  getIt.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<EditProfileCubit>(
    () => EditProfileCubit(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<ChangePasswordCubit>(
    () => ChangePasswordCubit(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<ContactUsCubit>(
    () => ContactUsCubit(
      repository: getIt<ContactUsRepository>(),
      service: getIt<ContactUsService>(),
    ),
  );
  getIt.registerLazySingleton<TermsCubit>(
    () => TermsCubit(getIt<TermsRepository>()),
  );
  getIt.registerLazySingleton<CourseCubit>(
    () => CourseCubit(
      courseRepository: getIt<CourseRepository>(),
      contentRepository: getIt<ContentRepository>(),
    ),
  );
  getIt.registerLazySingleton<HomeCubit>(
    () => HomeCubit(getIt<HomeRepository>()),
  );
  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(getIt<SignupRepository>()),
  );
  getIt.registerLazySingleton<LoginCubit>(
    () => LoginCubit(getIt<LoginRepository>()),
  );

  // My Courses
  getIt.registerLazySingleton<MyCoursesService>(() => MyCoursesService());
  getIt.registerLazySingleton<MyCoursesRepository>(
    () => MyCoursesRepositoryImpl(getIt<MyCoursesService>()),
  );
  getIt.registerLazySingleton<MyCoursesCubit>(
    () => MyCoursesCubit(getIt<MyCoursesRepository>()),
  );

  // Subscription
  getIt.registerLazySingleton<SubscriptionService>(() => SubscriptionService());
  getIt.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(getIt<SubscriptionService>()),
  );
  getIt.registerLazySingleton<SubscriptionCubit>(
    () => SubscriptionCubit(getIt<SubscriptionRepository>()),
  );
}
