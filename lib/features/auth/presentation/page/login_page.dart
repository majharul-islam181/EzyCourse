import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/blocs/password_visibility_cubit.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_snakbar.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.read<LoginBloc>().add(
      LoginSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (final BuildContext context, final LoginState state) {
        if (state.isSuccess) {
          CustomSnackBar.show(
            context: context,
            message: 'Login successful.',
            type: SnackBarType.success,
          );
          context.goNamed(AppRouteNames.coachingList);
        }

        if (state.isFailure && state.errorMessage != null) {
          CustomSnackBar.show(
            context: context,
            message: state.errorMessage!,
            type: SnackBarType.error,
          );
        }
      },
      builder: (final BuildContext context, final LoginState state) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.spacing.pagePadding),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(context.spacing.cardPadding),
                      child: Form(
                        key: _formKey,
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
                              controller: _emailController,
                              enabled: !state.isLoading,
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
                                      controller: _passwordController,
                                      enabled: !state.isLoading,
                                      obscureText: !isPasswordVisible,
                                      textInputAction: TextInputAction.done,
                                      autofillHints: const [
                                        AutofillHints.password,
                                      ],
                                      validator: AppValidators.password,
                                      onFieldSubmitted: (_) => state.isLoading
                                          ? null
                                          : _onLoginPressed(),
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: state.isLoading
                                              ? null
                                              : () {
                                                  context
                                                      .read<
                                                        PasswordVisibilityCubit
                                                      >()
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
                            if (state.isFailure &&
                                state.errorMessage != null) ...[
                              SizedBox(height: context.spacing.inputGap),
                              _LoginErrorMessage(message: state.errorMessage!),
                            ],
                            SizedBox(height: context.spacing.md),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: state.isLoading
                                    ? null
                                    : _onLoginPressed,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 180),
                                  child: state.isLoading
                                      ? SizedBox(
                                          key: const ValueKey<String>(
                                            'loading',
                                          ),
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
            ),
          ),
        );
      },
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
