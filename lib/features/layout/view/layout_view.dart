import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/context_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_drawer.dart';
import '../../auth/viewmodel/auth_cubit.dart';
import '../../course/viewmodels/course_cubit.dart';
import '../../auth/viewmodel/auth_state.dart';
import '../../home/view/home_view.dart';
import '../../my_courses/view/my_courses_view.dart';
import '../../my_courses/viewmodel/my_courses_cubit.dart';
import '../../my_courses/viewmodel/my_courses_state.dart';
import '../../profile/viewmodels/edit_profile_cubit.dart';
import '../../profile/viewmodels/profile_cubit.dart';
import '../../profile/viewmodels/profile_state.dart';
import '../../profile/views/profile_view.dart';
import '../viewmodel/layout_cubit.dart';
import '../../home/viewmodel/home_cubit.dart';
import '../../../core/di/injection.dart';

/// Main application shell with bottom navigation.
///
/// Behavior changes depending on [AuthState]:
///   • **Authenticated**: Full bottom nav → My Courses, Home, Profile.
///   • **Guest**: Bottom nav visible but "My Courses" and "Profile" tabs show
///     a guest banner with "Login" and "Join Now" buttons.
class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  Widget _navIcon(String asset, bool active) => Image.asset(
        asset,
        color: active ? AppColors.secondColor : AppColors.lightGray,
        scale: 4.5,
      );

  /// Builds the list of pages based on auth state.
  List<Widget> _pages(BuildContext context, bool isLoggedIn) => [
        // Tab 0 — My Courses (authenticated) or Guest banner
        isLoggedIn ? const MyCoursesView() : _buildGuestBanner(context),
        // Tab 1 — Home (always accessible)
        const HomeView(),
        // Tab 2 — Profile (authenticated) or Guest banner
        isLoggedIn
            ? MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: getIt<ProfileCubit>()),
                  BlocProvider.value(value: getIt<EditProfileCubit>()),
                ],
                child: const ProfileView(),
              )
            : _buildGuestBanner(context),
      ];

  /// Banner shown to guest users in place of restricted tabs.
  Widget _buildGuestBanner(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: AppColors.brand),
              const SizedBox(height: 16),
              Text(
                'هذا المحتوى متاح للمستخدمين المسجلين فقط',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 32),

              // ── Login button → clears guest status and returns to /login ──
              CustomButton(
                text: 'تسجيل دخول',
                backgroundColor: AppColors.brand,
                foregroundColor: Colors.white,
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  context.go(AppRouter.login);
                },
              ),
              const SizedBox(height: 12),

              // ── Join Now button → same as login for now ──
              CustomButton(
                text: 'انضم الآن',
                backgroundColor: AppColors.secondColor,
                foregroundColor: AppColors.brand,
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  context.go(AppRouter.login);
                },
              ),
            ],
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LayoutCubit()),
        BlocProvider.value(value: getIt<ProfileCubit>()),
        BlocProvider.value(value: getIt<HomeCubit>()),
        BlocProvider.value(value: getIt<CourseCubit>()),
        BlocProvider.value(value: getIt<MyCoursesCubit>()),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final isLoggedIn = authState.isLoggedIn;

          // Fetch profile if logged in and not already fetched
          if (isLoggedIn) {
            final profileState = context.read<ProfileCubit>().state;
            if (profileState.status == ProfileStatus.initial) {
              context.read<ProfileCubit>().getProfile();
            }
            final myCoursesState = context.read<MyCoursesCubit>().state;
            if (myCoursesState.status == MyCoursesStatus.initial) {
              context.read<MyCoursesCubit>().getMyCourses();
            }
          }

          return BlocBuilder<LayoutCubit, LayoutState>(
            builder: (context, layoutState) {
              final currentIndex = layoutState.currentIndex;

              return Scaffold(
                appBar: currentIndex == 2 && isLoggedIn
                    ? null
                    : AppBar(
                        title:
                            Image.asset('assets/splash/FRONT.png', scale: 11),
                      ),
                endDrawer: currentIndex == 2 && isLoggedIn
                    ? null
                    : const CustomDrawer(),
                body: IndexedStack(
                  index: currentIndex,
                  children: _pages(context, isLoggedIn),
                ),
                bottomNavigationBar: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, profileState) {
                    final name = isLoggedIn && profileState.profile != null
                        ? profileState.profile!.firstName
                        : 'حسابي';

                    return SizedBox(
                      height: 80,
                      child: BottomNavigationBar(
                        currentIndex: currentIndex,
                        onTap: (index) =>
                            context.read<LayoutCubit>().changePage(index),
                        items: [
                          BottomNavigationBarItem(
                            icon: _navIcon(
                              'assets/bottom_navigation_bar/MY_COURSE.png',
                              currentIndex == 0,
                            ),
                            label: 'دوراتي',
                          ),
                          BottomNavigationBarItem(
                            icon: _navIcon(
                              'assets/bottom_navigation_bar/HOME.png',
                              currentIndex == 1,
                            ),
                            label: 'الرئيسيه',
                          ),
                          BottomNavigationBarItem(
                            icon: _navIcon(
                              'assets/bottom_navigation_bar/PROFILE.png',
                              currentIndex == 2,
                            ),
                            label: name,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
