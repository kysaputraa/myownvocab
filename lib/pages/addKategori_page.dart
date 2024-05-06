import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/auth/auth_bloc.dart';
import 'package:myownvocab/blocs/vocab/vocab_bloc.dart';
import 'package:myownvocab/repository/main_repo.dart';
import 'package:myownvocab/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddKategoriPage extends StatefulWidget {
  const AddKategoriPage({super.key});

  @override
  State<AddKategoriPage> createState() => _AddKategoriPageState();
}

class _AddKategoriPageState extends State<AddKategoriPage> {
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    VocabBloc vocabbloc = context.read<VocabBloc>();
    MainRepository mainRepository = MainRepository();
    String uid = PreferenceUtils.getString("uid");

    return Scaffold(
      appBar: AppBar(title: const Text("ADD CATEGORY")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: name,
                autocorrect: false,
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: "Input Category Name ...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              vocabbloc.add(VocabEventAddKategori(name: name.text, uid: uid));
            },
            child: BlocConsumer<VocabBloc, VocabState>(
              listener: (context, state) {
                if (state is VocabCompleteAddKategori) {
                  context.pop();
                  mainRepository.toastMessage(context, "SUCCESS !");
                }
              },
              builder: (context, state) {
                if (state is VocabLoading) {
                  return const Text('LOADING');
                }
                return const Text('ADD');
              },
            ),
          ),
        ],
      ),
    );
  }
}
