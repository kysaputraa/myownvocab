import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myownvocab/blocs/vocab/vocab_bloc.dart';
import 'package:myownvocab/routes/router.dart';
import 'package:myownvocab/session.dart';

class VocabKategoriPage extends StatefulWidget {
  const VocabKategoriPage({super.key});

  @override
  State<VocabKategoriPage> createState() => _VocabKategoriPageState();
}

class _VocabKategoriPageState extends State<VocabKategoriPage> {
  @override
  Widget build(BuildContext context) {
    String userId = PreferenceUtils.getString("uid");
    VocabBloc vocabBloc = context.read<VocabBloc>();
    vocabBloc.add(VocabEventKategori(uid: userId));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade800,
        onPressed: () {
          context.goNamed(Routes.addKategori);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("LIST CATEGORY")),
      body: BlocConsumer<VocabBloc, VocabState>(
        bloc: vocabBloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          // print(state.toString());
          if (state is VocabError) {
            return Text('Error : ${state.message}');
          } else if (state is VocabLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VocabCompleteKategori) {
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
                    onTap: () => context.goNamed(
                      Routes.masterPage,
                      // queryParameters: {
                      //   "id": state.data[index]['uid'],
                      // }
                      extra: state.data[index]['id'],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                state.data[index]['name'].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: '/hello',
                                  child: Text("Edit"),
                                  onTap: () {
                                    context.goNamed(Routes.editKategori,
                                        queryParameters: {
                                          "id": state.data[index]["id"],
                                          "name": state.data[index]['name'],
                                        });
                                  },
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          // return const Center(child: Text("Something Went Wrong !"));
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
