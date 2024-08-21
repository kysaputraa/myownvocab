import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myownvocab/blocs/latihan/latihan_bloc.dart';
import 'package:myownvocab/blocs/vocab/vocab_bloc.dart';

class LatihanVocabPage extends StatefulWidget {
  final String id_kategori;
  const LatihanVocabPage({super.key, required this.id_kategori});

  @override
  State<LatihanVocabPage> createState() => _LatihanVocabPageState();
}

class _LatihanVocabPageState extends State<LatihanVocabPage> {
  LatihanBloc latihanBloc = LatihanBloc();
  var index = 0;
  var jumlah = 0;
  var benar = 0;
  var salah = 0;

  Future<void> _dialogBuilder(BuildContext context, int benar, int salah) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SELESAI '),
          content: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Benar : $benar \n'
                    'Salah : $salah \n'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _dialogBuilderJawaban(
      BuildContext context, int benar, String jawaban, String q, String a) {
    String status = benar == 1 ? "Correct" : "Wrong";
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(status),
          content: Text(
            'The meaning of the word $q is $a, and you have answered $jawaban',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("id kategori${widget.id_kategori}");
    final TextEditingController jawaban = TextEditingController();

    final CollectionReference stream = FirebaseFirestore.instance
        .collection('kategori')
        .doc(widget.id_kategori)
        .collection('vocab');
    return Scaffold(
      body: StreamBuilder(
        stream: stream.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong : ${snapshot.error.toString()}',
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final randomizedList = (snapshot.data!).docs;
          randomizedList.shuffle();
          jumlah = randomizedList.length;

          if (jumlah == 0) {
            return const Center(
              child: Text("Empty !"),
            );
          }

          latihanBloc.add(
            LatihanEventInitial(
                lang_1: randomizedList[index]['lang_1'],
                lang_2: randomizedList[index]['lang_2'],
                jumlah: jumlah),
          );

          return BlocConsumer<LatihanBloc, LatihanState>(
            bloc: latihanBloc,
            listener: (context, state) {},
            // buildWhen: (previous, current) {
            //   return jumlah > index + 1 ? true : false;
            // },
            builder: (context, state) {
              if (state is LatihanLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LatihanComplete) {
                print(jumlah);

                if (jumlah == 0) {
                  return const Center(
                    child: Text("Empty Data !"),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(
                                width: 2,
                                color: Colors.green.shade800,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text("${index + 1} / $jumlah")),
                              ),
                              Expanded(
                                flex: 4,
                                child: Center(
                                  child: Text("${state.lang_1}".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(
                                  height: 20,
                                  child: Text("Corrects : ${state.benar}")),
                              SizedBox(
                                  height: 40,
                                  child: Text("Wrongs : ${state.salah}")),
                            ],
                          )),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: jawaban,
                          autocorrect: false,
                          keyboardType: TextInputType.text,
                          maxLength: 20,
                          decoration: InputDecoration(
                            labelText: "Answer",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(40)),
                            onPressed: () {
                              if (jawaban.text.toLowerCase() ==
                                  state.lang_2.toLowerCase()) {
                                benar = 1;
                                salah = 0;
                              } else {
                                benar = 0;
                                salah = 1;
                              }
                              if (jumlah <= index + 1) {
                                latihanBloc.add(LatihanEventAnswer(
                                    lang_1: "",
                                    lang_2: "",
                                    benar: state.benar + benar,
                                    salah: state.salah + salah,
                                    jumlah: jumlah));
                                _dialogBuilder(context, state.benar + benar,
                                    state.salah + salah);
                                _dialogBuilderJawaban(context, benar,
                                    jawaban.text, state.lang_1, state.lang_2);
                              } else {
                                index = index + 1;
                                latihanBloc.add(LatihanEventAnswer(
                                    lang_1: randomizedList[index]['lang_1'],
                                    lang_2: randomizedList[index]['lang_2'],
                                    benar: state.benar + benar,
                                    salah: state.salah + salah,
                                    jumlah: jumlah));
                                _dialogBuilderJawaban(context, benar,
                                    jawaban.text, state.lang_1, state.lang_2);
                                jawaban.text = "";
                              }
                            },
                            child: const Text("ANSWER")),
                      ],
                    ),
                  ),
                );
              }
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
            },
          );

          // return ListView.builder(
          //   itemCount: randomizedList.length,
          //   itemBuilder: (context, index) {
          //     return Text(
          //       randomizedList[index]['lang_1'].toString(),
          //     );
          //   },
          // );
        },
      ),
    );
  }
}
