import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerb/src/core/di/di_initializer.dart';
import 'package:kerb/src/core/di/service_locator.dart';
import 'package:kerb/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kerb/src/features/auth/presentation/pages/sign_in_page.dart';
import 'package:kerb/src/features/sessions/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServiceLocator();
  runApp(const KerbApp());
}

class KerbApp extends StatelessWidget {
  const KerbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => serviceLocator<AuthBloc>()..add(const AuthStarted()),
      child: MaterialApp(
        title: 'Kerb',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, AuthState state) {
            return switch (state) {
              AuthSignedIn() => const HomePage(),
              _ => const SignInPage(),
            };
          },
        ),
      ),
    );
  }
}
