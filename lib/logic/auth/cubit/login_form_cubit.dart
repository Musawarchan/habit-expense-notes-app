import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginFormState extends Equatable {
  final String email;
  final String password;
  final bool isLoading;
  final bool obscurePassword;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.obscurePassword = true,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? obscurePassword,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object?> get props => [email, password, isLoading, obscurePassword];
}

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  void updateEmail(String value) => emit(state.copyWith(email: value));
  void updatePassword(String value) => emit(state.copyWith(password: value));
  void setLoading(bool value) => emit(state.copyWith(isLoading: value));
  void togglePasswordVisibility() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
}
