import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/vocab/vocab_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myownvocab/routes/router.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({super.key});

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  @override
  Widget build(BuildContext context) {
    VocabBloc vocabBloc = context.read<VocabBloc>();

    // Vocab vocab = context.read<Vocab>();
    // Stream<QuerySnapshot<Vocab>> stream = FirebaseFirestore.instance
    //     .collection('vocab')
    //     .withConverter<Vocab>(
    //       fromFirestore: (snapshot, _) => Vocab.fromJson(snapshot.data()!),
    //       toFirestore: (vocab, _) => vocab.toJson(),
    //     )
    //     .snapshots();

    final CollectionReference stream =
        FirebaseFirestore.instance.collection('vocab');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(Routes.addVocab);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("DAFTAR VOCAB")),
      body: StreamBuilder(
        stream: stream.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // List<Vocab> allVocabs = [];

          // for (var element in snapshot.data!.docs) {
          //   allVocabs.add(element.data());
          // }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              // Vocab vocab = allVocabs[index];
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(9),
                  onTap: () {
                    // context.goNamed(
                    //   Routes.detailVocab,
                    //   pathParameters: {
                    //     "productId": documentSnapshot['lang_1'],
                    //   },
                    // );
                    print(documentSnapshot.id);
                  },
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.all(15),
                    child: Row(children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 10, 47, 117),
                                  width: 2.0,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  index.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                            ),
                            Expanded(
                                child: Center(
                                    child: Text(documentSnapshot['lang_1']))),
                            const VerticalDivider(
                              thickness: 3,
                            ),
                            Expanded(
                                child: Center(
                                    child: Text(documentSnapshot['lang_2']))),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 1,
                      ),
                      BlocConsumer<VocabBloc, VocabState>(
                        listener: (context, state) {
                          print("object");
                          if (state is VocabCompleteDelete) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Deleted !")));
                          } else if (state is VocabError) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Failed ; Message : ${state.message} !")));
                          }
                        },
                        builder: (context, state) {
                          return PopupMenuButton(
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: '/hello',
                                  child: Text("Edit"),
                                  onTap: () {
                                    context.goNamed(Routes.editVocab,
                                        queryParameters: {
                                          "id": documentSnapshot.id
                                        });
                                  },
                                ),
                                PopupMenuItem(
                                  value: '/about',
                                  child: Text("Delete"),
                                  onTap: () {
                                    vocabBloc.add(VocabEventDelete(
                                        id: documentSnapshot.id.toString()));
                                  },
                                ),
                              ];
                            },
                          );
                        },
                      )
                    ]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
