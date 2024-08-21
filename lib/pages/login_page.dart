import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/auth/auth_bloc.dart';
import 'package:myownvocab/repository/main_repo.dart';
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
    email.text = "";
    password.text = "";

    MainRepository mainRepository = MainRepository();

    void prosesLogin(String email, String password) {
      authBloc.add(AuthEventLogin(email: email, password: password));
    }

    void getCurrentUserInfo() async {
      final auth = await FirebaseAuth.instance.currentUser;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed : ${auth?.email}"),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is AuthLoading) {
            mainRepository.loadingDialog(context);
          } else if (state is AuthError) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed : ${state.message}"),
              ),
            );
          } else if (state is AuthSuccess) {
            context.pop();
            context.goNamed(Routes.homePage);
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/MyOwnVocab.png',
                  width: 300,
                  height: 150,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: email,
                  // initialValue: 'rezkysaputra96@gmail.com',
                  decoration: const InputDecoration(
                    hintText: 'Input Email',
                    // filled: true,
                    // fillColor: Color.fromARGB(255, 236, 236, 236),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    // filled: true,
                    // fillColor: Color.fromARGB(255, 236, 236, 236),
                    hintText: 'Input Password',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40)),
                    onPressed: () {
                      prosesLogin(
                          email.text.toString(), password.text.toString());
                    },
                    icon: const Icon(Icons.login),
                    label: const Text("LOGIN")),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Doesnt have an account ? "),
                    InkWell(
                      onTap: () {
                        context.goNamed(Routes.registerPage);
                        // mainRepository.loadingDialog(context);
                        // mainRepository.toastMessage(context, "TES");
                      },
                      child: const Text(
                        "Register Here",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
