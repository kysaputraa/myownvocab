import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/vocab/vocab_bloc.dart';
import 'package:myownvocab/repository/main_repo.dart';
import 'package:myownvocab/routes/router.dart';
import 'package:myownvocab/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LatihanKategoriPage extends StatefulWidget {
  const LatihanKategoriPage({super.key});

  @override
  State<LatihanKategoriPage> createState() => _LatihanKategoriPageState();
}

class _LatihanKategoriPageState extends State<LatihanKategoriPage> {
  String _uid = '';

  @override
  void initState() {
    super.initState();
    // getSharedPrefs();
  }

  // void getSharedPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _uid = prefs.get('uid').toString();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    VocabBloc vocabBloc = context.read<VocabBloc>();
    String userId = PreferenceUtils.getString("uid");

    BlocProvider.of<VocabBloc>(context).add(VocabEventKategori(uid: userId));
    return Scaffold(
      appBar: AppBar(title: Text("CATEGORY")),
      body: BlocConsumer<VocabBloc, VocabState>(
        bloc: vocabBloc,
        listener: (context, state) {},
        builder: (context, state) {
          print(state.toString());
          if (state is VocabError) {
            return Text('Error : ${state.message}');
          } else if (state is VocabLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "Loading ...",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            );
          }
          if (state is VocabCompleteKategori) {
            if (state.data.length == 0) {
              return const Center(
                child: Text("Empty !"),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () =>
                        context.goNamed(Routes.latihanVocab, queryParameters: {
                      "id_kategori": state.data[index]['id'],
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Center(
                          child: Text(
                        state.data[index]['name'].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text("Something Went Wrong !"),
          );
        },
      ),
    );
  }
}
