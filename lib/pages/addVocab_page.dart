import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/vocab/vocab_bloc.dart';

class AddVocabPage extends StatefulWidget {
  final String id_kategori;
  AddVocabPage({super.key, required this.id_kategori});

  @override
  State<AddVocabPage> createState() => _AddVocabPageState();
}

class _AddVocabPageState extends State<AddVocabPage> {
  TextEditingController lang1 = TextEditingController();
  TextEditingController lang2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    VocabBloc vocabbloc = context.read<VocabBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text("TAMBAH VOCAB")),
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
                controller: lang1,
                autocorrect: false,
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: "Language First",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: lang2,
                autocorrect: false,
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: "Language Second",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              vocabbloc.add(VocabEventAdd(
                  lang1: lang1.text,
                  lang2: lang2.text,
                  id_kategori: widget.id_kategori.toString()));
            },
            child: BlocConsumer<VocabBloc, VocabState>(
              listener: (context, state) {
                if (state is VocabCompleteAdd) {
                  context.pop();
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
