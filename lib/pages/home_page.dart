import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/bloc/auth_bloc.dart';
import 'package:myownvocab/routes/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    final user = FirebaseAuth.instance.currentUser;

    void getUser() {
      print(user);
    }

    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        if (state != AuthSuccess()) {
          context.goNamed(Routes.loginPage);
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            authBloc.add(AuthEventLogout());
          },
          child: const Icon(Icons.logout),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                getUser();
              },
              child: Text("data")),
        ),
      ),
    );
  }
}
