import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/viewmodel/auth_cubit.dart';
import '../helpers/context_extensions.dart';

/// Animated splash screen — the initial route of the app.
///
/// After the intro animation completes, it triggers [AuthCubit.checkAuthStatus].
/// GoRouter's redirect logic then automatically navigates to either /login or
/// /main based on the resolved auth state.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideUpAnimation;
  late Animation<Offset> _slideDownAnimation;
  late Animation<double> _scaleFrontAnimation;
  late Animation<double> _scaleBackAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideDownAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleFrontAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleBackAnimation = Tween<double>(
      begin: 1.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Animation done → ask AuthCubit to resolve the persisted auth state.
          // GoRouter's redirect will handle the navigation automatically.
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.read<AuthCubit>().checkAuthStatus();
            }
          });
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: SlideTransition(
              position: _slideUpAnimation,
              child: Image.asset(
                'assets/splash/UP.png',
                fit: BoxFit.cover,
                width: context.width * 0.55,
                height: context.height * 0.3,
              ),
            ),
          ),

          Center(
            child: Stack(
              children: [
                ScaleTransition(
                  scale: _scaleBackAnimation,
                  child: Image.asset(
                    'assets/splash/BACK.png',
                    width: context.width * 0.6,
                    height: context.height * 0.4,
                  ),
                ),
                Positioned(
                  left: context.width * 0.1,
                  top: context.height * 0.06,
                  child: ScaleTransition(
                    scale: _scaleFrontAnimation,
                    child: Image.asset(
                      'assets/splash/FRONT.png',
                      width: context.width * 0.4,
                      height: context.height * 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: _slideDownAnimation,
              child: Image.asset(
                'assets/splash/DOWN.png',
                fit: BoxFit.cover,
                width: context.width * 0.5,
                height: context.height * 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
