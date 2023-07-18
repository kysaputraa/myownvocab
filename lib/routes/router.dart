import 'package:go_router/go_router.dart';
import 'package:myownvocab/pages/home_page.dart';
import 'package:myownvocab/pages/login_page.dart';
part 'route_name.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: Routes.loginPage,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/${Routes.homePage}',
      name: Routes.homePage,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
