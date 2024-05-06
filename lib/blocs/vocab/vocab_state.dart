part of 'vocab_bloc.dart';

abstract class VocabState {}

class VocabInitial extends VocabState {}

class VocabLoading extends VocabState {}

class VocabLoadingAddKategori extends VocabState {}

class VocabLoadingDeleteKategori extends VocabState {}

class VocabCompleteAdd extends VocabState {}

class VocabCompleteAddKategori extends VocabState {}

class VocabCompleteUpdate extends VocabState {}

class VocabCompleteUpdateKategori extends VocabState {}

class VocabCompleteKategori extends VocabState {
  List data;
  VocabCompleteKategori({
    required this.data,
  });
}

class VocabCompleteDelete extends VocabState {}

class VocabCompleteDeleteKategori extends VocabState {}

class VocabLatihanComplete extends VocabState {
  String lang_1;
  String lang_2;
  int benar;
  int salah;
  int sisa;
  VocabLatihanComplete(
      {required this.sisa,
      required this.lang_1,
      required this.lang_2,
      required this.benar,
      required this.salah});
}

class VocabError extends VocabState {
  String message;
  VocabError(this.message);
}
