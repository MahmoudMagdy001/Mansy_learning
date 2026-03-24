import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/viewmodel/auth_cubit.dart';
import '../../features/auth/viewmodel/auth_state.dart';
import '../../features/profile/viewmodels/profile_cubit.dart';
import '../../features/profile/viewmodels/profile_state.dart';
import '../helpers/context_extensions.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Center(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final isLoggedIn = authState.isLoggedIn;

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  color: const Color(0xff013567),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // صورة وبيانات اليوزر
                      const CircleAvatar(
                          radius: 35, child: Icon(Icons.person, size: 40)),
                      const SizedBox(height: 12),
                      if (isLoggedIn)
                        BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, profileState) {
                            final profile = profileState.profile;
                            return Column(
                              children: [
                                Text(
                                  profile?.fullName ?? 'جاري التحميل...',
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  profile?.email ?? '',
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      else
                        Text(
                          'زائر',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'الصفحة الشخصيه',
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff013567),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/bottom_navigation_bar/PROFILE.png',
                      width: 30,
                      height: 30,
                      color: const Color(0xff013567),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Color(0xff013567),
                  thickness: 1.5,
                  indent: 0,
                  endIndent: 20,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    context.pop(); // Close drawer
                    context.push('/contact-us');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'تواصل معنا',
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff013567),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'assets/home/Vector.png',
                        width: 30,
                        height: 30,
                        color: const Color(0xff013567),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    context.pop(); // Close drawer
                    context.push('/terms-and-conditions');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'الشروط والأحكام',
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff013567),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.description_outlined,
                        size: 30,
                        color: Color(0xff013567),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (isLoggedIn || authState.isGuest)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff013567),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                      },
                      child: const Text('تسجيل الخروج'),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
