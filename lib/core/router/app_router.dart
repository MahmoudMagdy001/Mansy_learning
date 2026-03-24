import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/viewmodel/auth_cubit.dart';
import '../../features/layout/view/layout_view.dart';
import '../../features/login/view/login_view.dart';
import '../../features/profile/viewmodels/change_password_cubit.dart';
import '../../features/profile/viewmodels/edit_profile_cubit.dart';
import '../../features/profile/views/change_password_view.dart';
import '../../features/profile/views/edit_profile_view.dart';
import '../../features/signup/views/signup_view.dart';
import '../../features/subscription/viewmodels/subscription_cubit.dart';
import '../../features/subscription/views/subscription_view.dart';
import '../../features/course/models/course_model.dart';
import '../../features/contact_us/views/contact_us_view.dart';
import '../../features/contact_us/viewmodels/contact_us_cubit.dart';
import '../../features/terms_and_conditions/views/terms_view.dart';
import '../../features/terms_and_conditions/viewmodels/terms_cubit.dart';
import '../../features/course/views/course_view.dart';
import '../../features/course/viewmodels/course_cubit.dart';
import '../../features/course/models/quiz_model.dart';
import '../../features/course/views/quiz_view.dart';
import '../../features/my_courses/viewmodel/my_courses_cubit.dart';
import '../di/injection.dart';
import '../widgets/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Central GoRouter configuration for the entire app.
///
/// Routes:
///   /splash  → SplashScreen (initial)
///   /login   → LoginView
///   /main    → LayoutView (main shell)
///
/// Redirect logic ensures unauthenticated users can't reach /main,
/// and authenticated/guest users skip /login.
class AppRouter {
  AppRouter(this._authCubit);

  final AuthCubit _authCubit;

  /// Route path constants — use these instead of raw strings.
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String contactUs = '/contact-us';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String course = '/course';
  static const String subscription = '/subscription';
  static const String quiz = '/quiz';

  late final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,

    /// Listens to [AuthCubit] stream so GoRouter re-evaluates the redirect
    /// every time the auth state changes.
    refreshListenable: _GoRouterRefreshStream(_authCubit.stream),

    redirect: (BuildContext context, GoRouterState state) {
      final authState = _authCubit.state;
      final currentPath = state.matchedLocation;

      // ── Still loading / checking auth → stay on splash ──
      if (!authState.isResolved) {
        return currentPath == splash ? null : splash;
      }

      final isLoggedIn = authState.isLoggedIn;
      final isGuest = authState.isGuest;
      final goingToLogin = currentPath == login;
      final goingToSignup = currentPath == signup;
      final goingToSplash = currentPath == splash;

      // ── User is authenticated or guest ──
      if (isLoggedIn || isGuest) {
        // Redirect away from splash/login → main
        if (goingToLogin || goingToSplash) return main;
        return null; // allow
      }

      // ── Unauthenticated ──
      // Only allow /login, /signup, and /splash; redirect everything else to /login
      if (!goingToLogin && !goingToSignup && !goingToSplash) return login;
      if (goingToSplash) return login;
      return null; // already going to /login
    },

    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignupView(),
      ),
      GoRoute(
        path: main,
        builder: (context, state) => const LayoutView(),
      ),
      GoRoute(
        path: editProfile,
        builder: (context, state) => BlocProvider.value(
          value: getIt<EditProfileCubit>(),
          child: const EditProfileView(),
        ),
      ),
      GoRoute(
        path: changePassword,
        builder: (context, state) => BlocProvider.value(
          value: getIt<ChangePasswordCubit>(),
          child: const ChangePasswordView(),
        ),
      ),
      GoRoute(
        path: contactUs,
        builder: (context, state) => BlocProvider.value(
          value: getIt<ContactUsCubit>(),
          child: const ContactUsView(),
        ),
      ),
      GoRoute(
        path: termsAndConditions,
        builder: (context, state) => BlocProvider.value(
          value: getIt<TermsCubit>(),
          child: const TermsAndConditionsView(),
        ),
      ),
      GoRoute(
        path: course,
        builder: (context, state) {
          final courseId = (state.extra as String?) ?? 'dummy_id';
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<CourseCubit>()),
              BlocProvider.value(value: getIt<SubscriptionCubit>()),
              BlocProvider.value(value: getIt<MyCoursesCubit>()),
            ],
            child: CourseView(courseId: courseId),
          );
        },
      ),
      GoRoute(
        path: subscription,
        builder: (context, state) {
          final course = state.extra as CourseModel;
          return BlocProvider.value(
            value: getIt<SubscriptionCubit>(),
            child: SubscriptionView(course: course),
          );
        },
      ),
      GoRoute(
        path: quiz,
        builder: (context, state) {
          final quiz = state.extra as QuizModel;
          return QuizView(quiz: quiz);
        },
      ),
    ],
  );
}

// -----------------------------------------------------------------------------
// Adapter: converts a Bloc [Stream] into a [Listenable] for GoRouter.
// -----------------------------------------------------------------------------
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners(); // initial evaluation
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
