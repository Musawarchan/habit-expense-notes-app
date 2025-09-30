import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../widgets/custom_widgets.dart';
import '../../../../logic/auth/bloc/auth_bloc.dart';
import '../../../../logic/auth/bloc/auth_event.dart';
import '../../../../logic/auth/bloc/auth_state.dart';
import '../../../../routes/app_pages.dart';
import '../../../../logic/auth/cubit/register_form_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppPages.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.onBackground,
          scrolledUnderElevation: 0,
          // title: Text(AppStrings.register),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(AppPages.login),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: BlocBuilder<RegisterFormCubit, RegisterFormState>(
                builder: (context, formState) {
                  final isLoading =
                      context.watch<AuthBloc>().state is AuthLoading;

                  void handleRegister() {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        AuthRegisterRequested(
                          email: formState.email.trim(),
                          password: formState.password.trim(),
                          name: formState.name.trim(),
                        ),
                      );
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.psychology,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Create Account',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join SmartLife and start your productivity journey',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),

                      CustomTextField(
                        label: 'Full Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                        onChanged: (v) =>
                            context.read<RegisterFormCubit>().updateName(v),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: AppStrings.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onChanged: (v) =>
                            context.read<RegisterFormCubit>().updateEmail(v),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: AppStrings.password,
                        obscureText: formState.obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        onChanged: (v) =>
                            context.read<RegisterFormCubit>().updatePassword(v),
                        suffixIcon: IconButton(
                          icon: Icon(
                            formState.obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => context
                              .read<RegisterFormCubit>()
                              .togglePasswordVisibility(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: AppStrings.confirmPassword,
                        obscureText: formState.obscureConfirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != formState.password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        onChanged: (v) => context
                            .read<RegisterFormCubit>()
                            .updateConfirmPassword(v),
                        suffixIcon: IconButton(
                          icon: Icon(
                            formState.obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => context
                              .read<RegisterFormCubit>()
                              .toggleConfirmPasswordVisibility(),
                        ),
                      ),
                      const SizedBox(height: 32),

                      CustomButton(
                        text: AppStrings.register,
                        onPressed: isLoading ? null : handleRegister,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Disable Google as not implemented
                      CustomButton(
                        text: AppStrings.signInWithGoogle,
                        onPressed: null,
                        isOutlined: true,
                        icon: Icons.g_mobiledata,
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppStrings.alreadyHaveAccount),
                          TextButton(
                            onPressed: () {
                              context.go('/login');
                            },
                            child: Text(AppStrings.login),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
