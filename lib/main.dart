import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'routes/app_routes.dart';
import 'logic/auth/bloc/auth_bloc.dart';
import 'logic/auth/repository/auth_repository.dart';
import 'logic/common/visibility_cubit.dart';
import 'logic/auth/cubit/login_form_cubit.dart';
import 'logic/auth/cubit/register_form_cubit.dart';
import 'logic/profile/bloc/profile_bloc.dart';
import 'logic/profile/repository/profile_repository.dart';
import 'logic/profile/bloc/profile_event.dart';
import 'logic/habit/bloc/habit_bloc.dart';
import 'logic/habit/repository/habit_repository.dart';
import 'logic/habit/bloc/habit_event.dart';
import 'logic/task/bloc/task_bloc.dart';
import 'logic/task/repository/task_repository.dart';
import 'logic/task/bloc/task_event.dart';
import 'logic/expense/bloc/expense_bloc.dart';
import 'logic/expense/repository/expense_repository.dart';
import 'logic/expense/bloc/expense_event.dart';
import 'logic/note/bloc/note_bloc.dart';
import 'logic/note/repository/note_repository.dart';
import 'logic/note/bloc/note_event.dart';

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
        // Authentication
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<VisibilityCubit>(
          create: (_) => VisibilityCubit(initial: true),
        ),
        BlocProvider<LoginFormCubit>(create: (_) => LoginFormCubit()),
        BlocProvider<RegisterFormCubit>(create: (_) => RegisterFormCubit()),

        // Profile
        BlocProvider<ProfileBloc>(
          create: (_) =>
              ProfileBloc(ProfileRepository())..add(const ProfileStarted()),
        ),

        // Habit Management
        BlocProvider<HabitBloc>(
          create: (_) =>
              HabitBloc(habitRepository: HabitRepository())
                ..add(const HabitLoadRequested()),
        ),

        // Task Management
        BlocProvider<TaskBloc>(
          create: (_) =>
              TaskBloc(taskRepository: TaskRepository())
                ..add(const TaskLoadRequested()),
        ),

        // Expense Management
        BlocProvider<ExpenseBloc>(
          create: (_) =>
              ExpenseBloc(expenseRepository: ExpenseRepository())
                ..add(const ExpenseLoadRequested()),
        ),

        // Note Management
        BlocProvider<NoteBloc>(
          create: (_) =>
              NoteBloc(noteRepository: NoteRepository())
                ..add(const NoteLoadRequested()),
        ),
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
