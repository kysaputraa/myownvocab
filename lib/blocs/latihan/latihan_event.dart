part of 'latihan_bloc.dart';

abstract class LatihanEvent {}

class LatihanEventAnswer extends LatihanEvent {
  String lang_1;
  String lang_2;
  int benar;
  int salah;
  int jumlah;
  LatihanEventAnswer({
    required this.lang_1,
    required this.lang_2,
    required this.benar,
    required this.salah,
    required this.jumlah,
  });
}

class LatihanEventInitial extends LatihanEvent {
  String lang_1;
  String lang_2;
  int jumlah;
  LatihanEventInitial({
    required this.lang_1,
    required this.lang_2,
    required this.jumlah,
  });
}
