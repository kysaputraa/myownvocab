part of 'vocab_bloc.dart';

abstract class VocabEvent {}

class VocabEventAdd extends VocabEvent {
  final String lang1;
  String lang2;

  VocabEventAdd({required this.lang1, required this.lang2});
}

class VocabEventUpdate extends VocabEvent {
  String lang1;
  String lang2;
  String id;

  VocabEventUpdate(
      {required this.lang1, required this.lang2, required this.id});
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
  VocabEventDelete({required this.id});
}

class VocabEventTes extends VocabEvent {
  int number;
  VocabEventTes({required this.number});
}
