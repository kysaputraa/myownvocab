import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/auth/auth_bloc.dart';
import 'package:myownvocab/pages/addKategori_page.dart';
import 'package:myownvocab/pages/addVocab_page.dart';
import 'package:myownvocab/pages/editKategori_page.dart';
import 'package:myownvocab/pages/editVocab_page.dart';
import 'package:myownvocab/pages/home_page.dart';
import 'package:myownvocab/pages/latihanKategori_page.dart';
import 'package:myownvocab/pages/latihanVocab_page.dart';
import 'package:myownvocab/pages/login_page.dart';
import 'package:myownvocab/pages/register_page.dart';
import 'package:myownvocab/pages/vocab_kategori.dart';
import 'package:myownvocab/pages/vocabs_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'route_name.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/${Routes.loginPage}',
  redirect: (context, state) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final isOnSignUp = state.location == '/${Routes.registerPage}';
    final isOnLogin = state.location == '/${Routes.loginPage}';
    final isOnHome = state.location == '/${Routes.homePage}';
    // final isLoggedIn = auth.currentUser != null;
    final isLoggedIn = prefs.get("uid") != null;

    // cek kondisi saat ini -> sedang terautentikasi
    if (isLoggedIn && isOnLogin) {
      BlocProvider.of<AuthBloc>(context).add(AuthEventSetLogin(
          uid: prefs.get('uid').toString(),
          email: prefs.get('email').toString()));
      return '/${Routes.homePage}';
    }
    ;
    if (isOnSignUp) return '/${Routes.registerPage}';
    if (!isLoggedIn && isOnHome) return '/${Routes.loginPage}';
  },
  routes: [
    GoRoute(
        path: '/${Routes.loginPage}',
        name: Routes.loginPage,
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: '${Routes.registerPage}',
            name: Routes.registerPage,
            builder: (context, state) => RegisterPage(),
          ),
        ]),
    GoRoute(
      path: '/${Routes.homePage}',
      name: Routes.homePage,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: Routes.vocabKategori,
          name: Routes.vocabKategori,
          builder: (context, state) => VocabKategoriPage(),
          routes: [
            GoRoute(
              path: 'masterPage',
              name: Routes.masterPage,
              builder: (context, state) =>
                  MasterPage(id: state.extra.toString()),
              routes: [
                GoRoute(
                  path: '${Routes.editVocab}',
                  name: Routes.editVocab,
                  builder: (context, state) => EditVocabPage(
                    id: state.queryParameters['id'].toString(),
                    id_kategori:
                        state.queryParameters['id_kategori'].toString(),
                  ),
                ),
                GoRoute(
                  path: '${Routes.addVocab}',
                  name: Routes.addVocab,
                  builder: (context, state) => AddVocabPage(
                    id_kategori: state.extra.toString(),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: Routes.addKategori,
              name: Routes.addKategori,
              builder: (context, state) => const AddKategoriPage(),
            ),
            GoRoute(
              path: Routes.editKategori,
              name: Routes.editKategori,
              builder: (context, state) => EditKategoriPage(
                id: state.queryParameters['id'].toString(),
                name: state.queryParameters['name'].toString(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: Routes.latihanKategori,
          name: Routes.latihanKategori,
          builder: (context, state) => LatihanKategoriPage(),
          routes: [
            GoRoute(
              path: '${Routes.latihanVocab}',
              name: Routes.latihanVocab,
              builder: (context, state) => LatihanVocabPage(
                id_kategori: state.queryParameters['id_kategori'].toString(),
              ),
            )
          ],
        )
      ],
    ),
  ],
);
