import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/blocs/password_visibility_cubit.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/validators.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onLoginPressed;

  const LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLoginPressed,
    this.errorMessage,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing.pagePadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(context.spacing.cardPadding),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Login',
                      style: context.text.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.spacing.sm),
                    Text(
                      'Welcome back to EzyCourse',
                      style: context.text.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.spacing.md),
                    TextFormField(
                      controller: emailController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: AppValidators.email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    SizedBox(height: context.spacing.inputGap),
                    BlocBuilder<PasswordVisibilityCubit, bool>(
                      builder:
                          (
                            final BuildContext context,
                            final bool isPasswordVisible,
                          ) {
                            return TextFormField(
                              controller: passwordController,
                              enabled: !isLoading,
                              obscureText: !isPasswordVisible,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              validator: AppValidators.password,
                              onFieldSubmitted: (_) =>
                                  isLoading ? null : onLoginPressed(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          context
                                              .read<PasswordVisibilityCubit>()
                                              .toggle();
                                        },
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                            );
                          },
                    ),
                    if (errorMessage != null) ...[
                      SizedBox(height: context.spacing.inputGap),
                      _LoginErrorMessage(message: errorMessage!),
                    ],
                    SizedBox(height: context.spacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : onLoginPressed,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: isLoading
                              ? SizedBox(
                                  key: const ValueKey<String>('loading'),
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  key: ValueKey<String>('label'),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginErrorMessage extends StatelessWidget {
  const _LoginErrorMessage({required this.message});

  final String message;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: context.radius.input,
      ),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error_outline,
              size: 18,
              color: colorScheme.onErrorContainer,
            ),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Text(
                message,
                style: context.text.labelSmall?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
