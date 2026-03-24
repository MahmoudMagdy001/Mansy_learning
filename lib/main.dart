import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/viewmodel/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://djvvjpnqkhgbdogpxnyo.supabase.co',
    anonKey: 'sb_publishable_F7q4x2KT3gKRg8-7W9Cx0Q_M31N9CTx',
  );
  
  setupDependencyInjection();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthCubit lives above the entire widget tree so it's accessible
    // from every route (splash, login, main layout).
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Builder(
        builder: (context) {
          // AppRouter needs the AuthCubit instance to wire up refresh
          // and redirect logic.
          final authCubit = context.read<AuthCubit>();
          final appRouter = AppRouter(authCubit);

          return MaterialApp.router(
            darkTheme: AppTheme.dark,
            theme: AppTheme.light,
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}
