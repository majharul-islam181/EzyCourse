import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/blocs/auth_session/auth_session_bloc.dart';
import '../../../../core/blocs/auth_session/auth_session_event.dart';
import '../../../../core/blocs/password_visibility_cubit/password_visibility_cubit.dart';
import '../../../../core/di/core_di.dart';
import '../../../../core/widgets/custom_snakbar.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../widget/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => sl<LoginBloc>()),
        BlocProvider<PasswordVisibilityCubit>(
          create: (_) => sl<PasswordVisibilityCubit>(),
        ),
      ],
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
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
          final session = state.session;
          if (session != null) {
            context.read<AuthSessionBloc>().add(
              AuthSessionAuthenticated(session.token),
            );
          }

          CustomSnackBar.show(
            context: context,
            message: 'Login successful.',
            type: SnackBarType.success,
          );
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
              child: LoginForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                isLoading: state.isLoading,
                errorMessage: state.isFailure ? state.errorMessage : null,
                onLoginPressed: _onLoginPressed,
              ),
            ),
          ),
        );
      },
    );
  }
}
