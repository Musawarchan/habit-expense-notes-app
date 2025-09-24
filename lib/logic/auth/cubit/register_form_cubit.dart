import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterFormState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  const RegisterFormState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
  });

  RegisterFormState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
  }) {
    return RegisterFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    confirmPassword,
    isLoading,
    obscurePassword,
    obscureConfirmPassword,
  ];
}

class RegisterFormCubit extends Cubit<RegisterFormState> {
  RegisterFormCubit() : super(const RegisterFormState());

  void updateName(String value) => emit(state.copyWith(name: value));
  void updateEmail(String value) => emit(state.copyWith(email: value));
  void updatePassword(String value) => emit(state.copyWith(password: value));
  void updateConfirmPassword(String value) =>
      emit(state.copyWith(confirmPassword: value));
  void setLoading(bool value) => emit(state.copyWith(isLoading: value));
  void togglePasswordVisibility() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
  void toggleConfirmPasswordVisibility() => emit(
    state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword),
  );
}
