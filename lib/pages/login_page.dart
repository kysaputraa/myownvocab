import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/auth/auth_bloc.dart';
import 'package:myownvocab/routes/router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();

    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

    void prosesLogin(String email, String password) {
      authBloc.add(AuthEventLogin(email: email, password: password));
    }

    void getCurrentUserInfo() async {
      final auth = await FirebaseAuth.instance.currentUser;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal : ${auth?.email}"),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Gagal : ${state.message}"),
              ),
            );
          } else if (state is AuthSuccess) {
            context.goNamed(Routes.homePage);
          }
        },
        builder: (context, state) {
          print(state);
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: email,
                  // initialValue: 'rezkysaputra96@gmail.com',
                  decoration: const InputDecoration(hintText: 'Masukkan Email'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40)),
                    onPressed: () {
                      prosesLogin(
                          email.text.toString(), password.text.toString());
                    },
                    icon: const Icon(Icons.login),
                    label: const Text("LOGIN")),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40)),
                    onPressed: () {
                      getCurrentUserInfo();
                    },
                    icon: const Icon(Icons.login),
                    label: const Text("GET"))
              ],
            ),
          );
        },
      ),
    );
  }
}
