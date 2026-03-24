import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/context_extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/viewmodel/auth_cubit.dart';
import '../../../auth/viewmodel/auth_state.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: double.infinity,
          height: 180,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/home/first.png'),
            ),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'المنسي  في الرياضيات',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          height: 1.5,
          width: 160,
          color: const Color(0xff013567),
        ),
        const SizedBox(height: 10),
        Text(
          'محمد منسي سليمان محمد',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xff013567),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          textAlign: TextAlign.right,
          'مع أستاذ محمد منسي القدرات ما راح تكون صعبة بعد اليوم لأنة راح يعلمك كيف تفكر، وكيف تحل وتسبق غيرك بثقة',
          style: context.textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state.isLoggedIn) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFFE569),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: () {},
                      child: Text(
                        'أنضم الأن',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: const Color(0xff013567),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: () {
                        // Logout first, then GoRouter redirect takes user to /login.
                        context.read<AuthCubit>().logout();
                        context.go(AppRouter.login);
                      },
                      child: Text(
                        'تسجيل دخول',
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}
