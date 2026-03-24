import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/helpers/context_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../auth/viewmodel/auth_cubit.dart';
import '../viewmodel/login_cubit.dart';
import '../viewmodel/login_state.dart';

/// Login screen with email / password form.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.success) {
              context.read<AuthCubit>().login();
            } else if (state.status == LoginStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'حدث خطأ ما')),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Graphic
                    SizedBox(
                      width: double.infinity,
                      height: 350,
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 0.8,
                            child: Image.asset(
                              'assets/splash/UP.png',
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/splash/BACK.png', height: 280),
                                    Image.asset('assets/splash/FRONT.png', height: 180),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Login Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تسجيل دخول',
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 100,
                            color: AppColors.brand.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),

                    // Form Fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'البريد الإلكتروني',
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: 'example@gmail.com',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            onTapOutside: (_) => FocusScope.of(context).unfocus(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال البريد الإلكتروني';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'كلمة المرور',
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: '********',
                              prefixIcon: const Icon(
                                Icons.visibility_off,
                                color: AppColors.brand,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            onTapOutside: (_) => FocusScope.of(context).unfocus(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال كلمة المرور';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 48),

                          // Login Button
                          CustomButton(
                            text: 'تسجيل دخول',
                            backgroundColor: AppColors.brand,
                            foregroundColor: Colors.white,
                            isLoading: state.status == LoginStatus.loading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginCubit>().login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                              }
                            },
                          ),
                          const SizedBox(height: 16),

                          // Continue as Guest Button
                          CustomButton(
                            text: 'الدخول كزائر',
                            backgroundColor: AppColors.secondColor,
                            foregroundColor: AppColors.brand,
                            onPressed: () =>
                                context.read<AuthCubit>().continueAsGuest(),
                          ),
                          const SizedBox(height: 24),

                          // Signup Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ليس لديك حساب؟ ',
                                style: context.textTheme.bodyMedium,
                              ),
                              GestureDetector(
                                onTap: () => context.push(AppRouter.signup),
                                child: const Text(
                                  'إنشاء حساب',
                                  style: TextStyle(
                                    color: AppColors.brand,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),

                          // Footer
                          const Center(
                            child: Text(
                              'كل الحقوق محفوظة 2025 © الشركة الوطنية N.I.T',
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
