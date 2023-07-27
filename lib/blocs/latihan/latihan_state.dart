part of 'latihan_bloc.dart';

abstract class LatihanState {}

class LatihanInitial extends LatihanState {}

class LatihanLoading extends LatihanState {}

class LatihanComplete extends LatihanState {
  String lang_1;
  String lang_2;
  int benar;
  int salah;
  int jumlah;
  LatihanComplete({
    required this.lang_1,
    required this.lang_2,
    required this.benar,
    required this.salah,
    required this.jumlah,
  });
}
