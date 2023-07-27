import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/pages/addVocab_page.dart';
import 'package:myownvocab/pages/editVocab_page.dart';
import 'package:myownvocab/pages/home_page.dart';
import 'package:myownvocab/pages/latihanVocab_page.dart';
import 'package:myownvocab/pages/login_page.dart';
import 'package:myownvocab/pages/vocabs_page.dart';
part 'route_name.dart';

// GoRouter configuration
final router = GoRouter(
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;
    // cek kondisi saat ini -> sedang terautentikasi
    if (auth.currentUser == null) {
      // tidak sedang login / tidak ada user yg aktif saat ini
      return '/${Routes.loginPage}';
    } else {
      return null;
    }
  },
  routes: [
    GoRoute(
      path: '/${Routes.loginPage}',
      name: Routes.loginPage,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/',
      name: Routes.homePage,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: '${Routes.masterPage}',
          name: Routes.masterPage,
          builder: (context, state) => const MasterPage(),
          routes: [
            GoRoute(
              path: '${Routes.editVocab}',
              name: Routes.editVocab,
              builder: (context, state) => EditVocabPage(
                id: state.queryParameters['id'].toString(),
              ),
            ),
            GoRoute(
              path: '${Routes.addVocab}',
              name: Routes.addVocab,
              builder: (context, state) => const AddVocabPage(),
            ),
          ],
        ),
        GoRoute(
          path: '${Routes.latihanVocab}',
          name: Routes.latihanVocab,
          builder: (context, state) => LatihanVocabPage(),
        )
      ],
    ),
  ],
);
