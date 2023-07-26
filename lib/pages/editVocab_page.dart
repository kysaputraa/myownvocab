import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/vocab/vocab_bloc.dart';

class EditVocab extends StatelessWidget {
  String? id;
  EditVocab({super.key, this.id});

  TextEditingController lang1 = TextEditingController();
  TextEditingController lang2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    VocabBloc vocabBloc = context.read<VocabBloc>();
    var streamVocabs =
        FirebaseFirestore.instance.collection('vocab').doc(id.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("EDIT VOCAB"),
      ),
      body: StreamBuilder(
          stream: streamVocabs.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            var vocab = snapshot.data;
            lang1.text = vocab?['lang_1'];
            lang2.text = vocab?['lang_2'];

            return ListView(
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
                      keyboardType: TextInputType.number,
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
                      keyboardType: TextInputType.number,
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
                    vocabBloc.add(VocabEventUpdate(
                        lang1: lang1.text,
                        lang2: lang2.text,
                        id: id.toString()));
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
              ],
            );
          }),
    );
  }
}
