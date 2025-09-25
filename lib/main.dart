import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartlife_app/logic/auth/bloc/auth_event.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'routes/app_routes.dart';
import 'logic/auth/bloc/auth_bloc.dart';
import 'logic/auth/repository/auth_repository.dart';
import 'logic/common/visibility_cubit.dart';
import 'logic/auth/cubit/login_form_cubit.dart';
import 'logic/auth/cubit/register_form_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive
  await Hive.initFlutter();

  // Request notification permission (best-effort)
  try {
    await FirebaseMessaging.instance.requestPermission();
  } catch (_) {}

  runApp(const SmartLifeApp());
}

class SmartLifeApp extends StatelessWidget {
  const SmartLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
          // ..add(const AuthStarted()),
        ),
        BlocProvider<VisibilityCubit>(
          create: (_) => VisibilityCubit(initial: true),
        ),
        BlocProvider<LoginFormCubit>(create: (_) => LoginFormCubit()),
        BlocProvider<RegisterFormCubit>(create: (_) => RegisterFormCubit()),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
