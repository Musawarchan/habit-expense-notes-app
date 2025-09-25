import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlife_app/logic/common/visibility_cubit.dart';
import 'package:smartlife_app/logic/auth/cubit/login_form_cubit.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_widgets.dart';
import '../../../../logic/auth/bloc/auth_bloc.dart';
import '../../../../logic/auth/bloc/auth_event.dart';
import '../../../../logic/auth/bloc/auth_state.dart';
import '../../../../routes/app_pages.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    void handleLogin(LoginFormState formState) {
      if (formKey.currentState!.validate()) {
        context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: formState.email.trim(),
            password: formState.password.trim(),
          ),
        );
      }
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go(AppPages.home);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: BlocBuilder<LoginFormCubit, LoginFormState>(
                builder: (context, formState) {
                  final isLoading =
                      context.watch<AuthBloc>().state is AuthLoading;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // const Spacer(),
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
                              AppStrings.appName,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.appTagline,
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
                              context.read<LoginFormCubit>().updateEmail(v),
                        ),
                        const SizedBox(height: 16),

                        BlocBuilder<VisibilityCubit, bool>(
                          builder: (context, obscure) => CustomTextField(
                            label: AppStrings.password,
                            obscureText: obscure,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            onChanged: (v) => context
                                .read<LoginFormCubit>()
                                .updatePassword(v),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () =>
                                  context.read<VisibilityCubit>().toggle(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement password reset flow using bloc
                            },
                            child: Text(AppStrings.forgotPassword),
                          ),
                        ),
                        const SizedBox(height: 24),

                        CustomButton(
                          text: AppStrings.login,
                          onPressed: isLoading
                              ? null
                              : () => handleLogin(formState),
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
                            Text(AppStrings.dontHaveAccount),
                            TextButton(
                              onPressed: () {
                                context.go(AppPages.register);
                              },
                              child: Text(AppStrings.register),
                            ),
                          ],
                        ),
                        // const Spacer(),
                      ],
                    ),
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
