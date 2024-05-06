import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/auth/auth_bloc.dart';
import 'package:myownvocab/routes/router.dart';
import 'package:myownvocab/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    Color warna1 = Colors.amber;
    Color warna2 = Colors.blue;

    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        if (state is AuthLogout) {
          context.goNamed(Routes.loginPage);
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 161, 44, 42),
          onPressed: () {
            authBloc.add(AuthEventLogout());
          },
          child: const Icon(Icons.logout),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Stack(children: [
                  Container(
                    color: warna2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: warna1,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(135)),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/img/MyOwnVocab.png',
                        height: 200,
                      ),
                    ),
                  ),
                ]),
              ),
              Expanded(
                flex: 2,
                child: Stack(children: [
                  Container(
                    color: warna1,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: warna2,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(135)),
                    ),
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: 2,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 100,
                        ),
                        itemBuilder: (context, index) {
                          late VoidCallback onTap;
                          late String title;
                          late IconData icon;
                          switch (index) {
                            case 0:
                              title = 'DATA MASTER';
                              onTap =
                                  () => context.goNamed(Routes.vocabKategori);
                              icon = Icons.dataset;
                              break;
                            case 1:
                              title = 'START';
                              onTap =
                                  () => context.goNamed(Routes.latihanKategori);
                              icon = Icons.quiz_rounded;
                              break;
                          }
                          return ElevatedButton.icon(
                            onPressed: onTap,
                            icon: Icon(icon),
                            label: Text(title),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                      height: 60,
                      child: const Center(
                        child: Text("Create your own Vocoublary",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  ])
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
