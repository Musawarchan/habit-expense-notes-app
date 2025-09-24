import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum SplashNavTarget { onboarding, login, home }

class SplashState {
  final bool isLoading;
  final SplashNavTarget? target;

  const SplashState({this.isLoading = true, this.target});

  SplashState copyWith({bool? isLoading, SplashNavTarget? target}) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      target: target ?? this.target,
    );
  }
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  Future<void> initialize() async {
    try {
      // permissions best-effort
      try {
        await FirebaseMessaging.instance.requestPermission();
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('device_fcm_token', token);
        }
      } catch (_) {}

      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

      if (!hasSeenOnboarding) {
        emit(
          state.copyWith(isLoading: false, target: SplashNavTarget.onboarding),
        );
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(state.copyWith(isLoading: false, target: SplashNavTarget.home));
      } else {
        emit(state.copyWith(isLoading: false, target: SplashNavTarget.login));
      }
    } catch (_) {
      emit(state.copyWith(isLoading: false, target: SplashNavTarget.login));
    }
  }
}
