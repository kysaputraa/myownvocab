import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myownvocab/blocs/auth/auth_bloc.dart';
import 'package:myownvocab/blocs/latihan/latihan_bloc.dart';
import 'package:myownvocab/blocs/repository/api_repository.dart';
import 'package:myownvocab/blocs/vocab/vocab_bloc.dart';
import 'package:myownvocab/routes/router.dart';
import 'package:myownvocab/session.dart';
import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PreferenceUtils.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<VocabBloc>(
          create: (context) => VocabBloc(ApiRepository()),
        ),
        BlocProvider<LatihanBloc>(
          create: (context) => LatihanBloc(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: Colors.grey.shade200,
          colorScheme:
              ThemeData().colorScheme.copyWith(primary: Colors.green.shade400),
        ),
        routerConfig: router,
      ),
    );
  }
}
