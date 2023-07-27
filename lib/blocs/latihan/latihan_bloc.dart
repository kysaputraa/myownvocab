import 'package:bloc/bloc.dart';

part 'latihan_event.dart';
part 'latihan_state.dart';

class LatihanBloc extends Bloc<LatihanEvent, LatihanState> {
  LatihanBloc() : super(LatihanInitial()) {
    on<LatihanEventAnswer>((event, emit) {
      emit(LatihanLoading());
      Future.delayed(const Duration(seconds: 1));
      emit(LatihanComplete(
          lang_1: event.lang_1,
          lang_2: event.lang_2,
          benar: event.benar,
          salah: event.salah,
          jumlah: event.jumlah)); //recommend
    });

    on<LatihanEventInitial>((event, emit) {
      emit(LatihanLoading());
      Future.delayed(const Duration(seconds: 1)); //recommend
      emit(LatihanComplete(
          lang_1: event.lang_1,
          lang_2: event.lang_2,
          benar: 0,
          salah: 0,
          jumlah: event.jumlah));
    });
  }
}
