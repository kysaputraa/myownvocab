part of 'vocab_bloc.dart';

abstract class VocabEvent {}

class VocabEventAdd extends VocabEvent {
  final String lang1;
  String lang2;
  String id_kategori;

  VocabEventAdd(
      {required this.lang1, required this.lang2, required this.id_kategori});
}

class VocabEventAddKategori extends VocabEvent {
  final String name;
  final String uid;

  VocabEventAddKategori({required this.name, required this.uid});
}

class VocabEventUpdate extends VocabEvent {
  String lang1;
  String lang2;
  String id;
  String id_kategori;

  VocabEventUpdate(
      {required this.lang1,
      required this.lang2,
      required this.id,
      required this.id_kategori});
}

class VocabEventUpdateKategori extends VocabEvent {
  String id;
  String name;

  VocabEventUpdateKategori({required this.id, required this.name});
}

class VocabEventLatihan extends VocabEvent {
  String lang_1;
  String lang_2;
  String jawaban;
  VocabEventLatihan(
      {required this.lang_1, required this.lang_2, required this.jawaban});
}

class VocabEventDelete extends VocabEvent {
  String id;
  String id_kategori;
  VocabEventDelete({required this.id, required this.id_kategori});
}

class VocabEventDeleteKategori extends VocabEvent {
  String id;
  VocabEventDeleteKategori({required this.id});
}

class VocabEventTes extends VocabEvent {
  int number;
  VocabEventTes({required this.number});
}

class VocabEventKategori extends VocabEvent {
  String uid;
  VocabEventKategori({required this.uid});
}
