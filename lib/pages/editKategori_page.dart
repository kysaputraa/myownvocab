import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/vocab/vocab_bloc.dart';
import 'package:myownvocab/models/vocab.dart';

class EditKategoriPage extends StatelessWidget {
  final String id;
  final String name;
  EditKategoriPage({super.key, required this.id, required this.name});

  final TextEditingController namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    VocabBloc vocabBloc = context.read<VocabBloc>();
    namecontroller.text = name.toString();

    return BlocListener<VocabBloc, VocabState>(
      listener: (context, state) {
        if (state is VocabCompleteUpdateKategori ||
            state is VocabCompleteDeleteKategori) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("SUCCESS !"),
            ),
          );
          context.pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("EDIT KATEGORI"),
          ),
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
                    controller: namecontroller,
                    autocorrect: false,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelText: "Category Name ...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  vocabBloc.add(VocabEventUpdateKategori(
                    name: namecontroller.text,
                    id: id.toString(),
                  ));
                },
                child: BlocConsumer<VocabBloc, VocabState>(
                  listener: (context, state) {
                    if (state is VocabCompleteUpdate) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("SUCCESS !"),
                        ),
                      );
                      context.pop();
                    } else if (state is VocabError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("FAILED : Message : ${state.message} !"),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is VocabLoading) {
                      return const Text('LOADING');
                    }
                    return const Text('UPDATE');
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 174, 20, 9)),
                onPressed: () {
                  vocabBloc.add(VocabEventDeleteKategori(
                    id: id.toString(),
                  ));
                },
                child: Text("DELETE"),
              )
            ],
          )),
    );
  }
}
