import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/auth/auth_bloc.dart';
import 'package:myownvocab/repository/main_repo.dart';
import 'package:myownvocab/routes/router.dart';
import 'package:myownvocab/widgets/InputForm.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordagain = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    MainRepository mainRepository = MainRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            mainRepository.loadingDialog(context);
          } else if (state is AuthSuccessSignUp) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("SUKSES !!"),
              ),
            );
            context.goNamed(Routes.loginPage);
          } else if (state is AuthError) {
            context.pop();
          }
        },
        child: Container(
          padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
          child: ListView(
            children: [
              InputForm(
                hint: "Input Email",
                icon: Icons.email,
                controller: email,
              ),
              InputForm(
                hint: "First Name",
                icon: Icons.text_fields,
                controller: firstName,
              ),
              InputForm(
                hint: "Last Name",
                icon: Icons.text_fields,
                controller: lastName,
              ),
              InputForm(
                password: true,
                hint: "Input Password",
                icon: Icons.text_fields,
                controller: password,
              ),
              InputForm(
                password: true,
                hint: "Input Password Again ",
                icon: Icons.text_fields,
                controller: passwordagain,
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: () {
                    if (password.text != passwordagain.text) {
                      mainRepository.toastMessage(
                          context, "Password is not same !");
                      return null;
                    }
                    authBloc.add(
                      AuthEventRegister(
                        email: email.text,
                        password: password.text,
                        firstName: firstName.text,
                        lastName: lastName.text,
                      ),
                    );
                  },
                  icon: const Icon(Icons.app_registration),
                  label: const Text("REGISTER")),
            ],
          ),
        ),
      ),
    );
  }
}
