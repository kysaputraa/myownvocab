import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/auth/auth_bloc.dart';
import 'package:myownvocab/routes/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();

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
          child: Container(
            margin: const EdgeInsets.all(50),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 2,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 100),
              itemBuilder: (context, index) {
                late VoidCallback onTap;
                late String title;
                late IconData icon;

                switch (index) {
                  case 0:
                    title = '${Routes.homePage}';
                    onTap = () => context.goNamed(Routes.masterPage);
                    icon = Icons.ac_unit_rounded;
                    break;
                  case 1:
                    title = 'Latihan';
                    onTap = () => context.goNamed(Routes.latihanVocab);
                    icon = Icons.addchart;
                    break;
                }
                return ElevatedButton.icon(
                  onPressed: onTap,
                  icon: Icon(icon),
                  label: Text(title),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
