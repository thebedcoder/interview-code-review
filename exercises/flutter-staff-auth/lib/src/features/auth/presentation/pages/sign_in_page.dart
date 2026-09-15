import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerb/src/features/auth/presentation/bloc/auth_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Pay for parking by the minute'),
            const SizedBox(height: 24),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (BuildContext context, AuthState state) {
                return FilledButton(
                  onPressed: state is AuthSigningIn
                      ? null
                      : () => context.read<AuthBloc>().add(
                          const AuthSignInRequested(),
                        ),
                  child: const Text('Sign in'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
