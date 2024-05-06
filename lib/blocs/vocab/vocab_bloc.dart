import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myownvocab/blocs/repository/api_repository.dart';
part 'vocab_event.dart';
part 'vocab_state.dart';

class VocabBloc extends Bloc<VocabEvent, VocabState> {
  ApiRepository apiRepository;

  VocabBloc(this.apiRepository) : super(VocabInitial()) {
    on<VocabEventAdd>((event, emit) async {
      try {
        emit(VocabLoading());
        await FirebaseFirestore.instance
            .collection("kategori")
            .doc(event.id_kategori)
            .collection('vocab')
            .add({
          "lang_1": event.lang1,
          "lang_2": event.lang2,
          "created_at": "asda",
          "created_by": "asda",
        });
        emit(VocabCompleteAdd());
      } on FirebaseException catch (e) {
        emit(VocabError(e.message.toString()));
      } catch (e) {
        emit(VocabError(e.toString()));
      }
    });

    on<VocabEventKategori>(vocabEventKategori);

    on<VocabEventAddKategori>((event, emit) async {
      try {
        emit(VocabLoading());
        await FirebaseFirestore.instance.collection("kategori").add({
          "name": event.name,
          'id': '',
          'uid': event.uid,
        }).then(
          (DocumentReference docRef) => docRef.update({'id': docRef.id}),
        );

        emit(VocabCompleteAddKategori());
      } on FirebaseException catch (e) {
        emit(VocabError(e.message.toString()));
      } catch (e) {
        emit(VocabError(e.toString()));
      }
    });

    on<VocabEventUpdate>((event, emit) async {
      try {
        emit(VocabLoading());
        await FirebaseFirestore.instance
            .collection("kategori")
            .doc(event.id_kategori)
            .collection("vocab")
            .doc(event.id)
            .update({
          "lang_1": event.lang1,
          "lang_2": event.lang2,
        });
        emit(VocabCompleteUpdate());
      } on FirebaseException catch (e) {
        emit(VocabError(e.message.toString()));
      } catch (e) {
        emit(VocabError(e.toString()));
      }
    });

    on<VocabEventUpdateKategori>((event, emit) async {
      try {
        emit(VocabLoading());
        await FirebaseFirestore.instance
            .collection("kategori")
            .doc(event.id)
            .update({
          "name": event.name,
        });
        emit(VocabCompleteUpdateKategori());
      } on FirebaseException catch (e) {
        emit(VocabError(e.message.toString()));
      } catch (e) {
        emit(VocabError(e.toString()));
      }
    });

    on<VocabEventDelete>((event, emit) async {
      try {
        emit(VocabLoading());
        await FirebaseFirestore.instance
            .collection("kategori")
            .doc(event.id_kategori)
            .collection("vocab")
            .doc(event.id)
            .delete();
        emit(VocabCompleteDelete());
      } on FirebaseException catch (e) {
        emit(VocabError(e.message.toString()));
      } catch (e) {
        emit(VocabError(e.toString()));
      }
    });

    on<VocabEventDeleteKategori>((event, emit) async {
      try {
        emit(VocabLoadingDeleteKategori());
        await FirebaseFirestore.instance
            .collection("kategori")
            .doc(event.id)
            .delete();
        emit(VocabCompleteDeleteKategori());
      } on FirebaseException catch (e) {
        emit(VocabError(e.message.toString()));
      } catch (e) {
        emit(VocabError(e.toString()));
      }
    });

    on<VocabEventTes>((event, emit) async {
      try {
        emit(VocabLoading());
        // if(event.jawaban == event.lang_2){

        // }
      } on FirebaseException catch (e) {
        emit(VocabError(e.message.toString()));
      } catch (e) {
        emit(VocabError(e.toString()));
      }
    });
  }

  FutureOr<void> vocabEventKategori(
      VocabEventKategori event, Emitter<VocabState> emit) async {
    emit(VocabLoading());
    try {
      final List allData = await apiRepository.getDataList(event.uid);
      emit(VocabCompleteKategori(data: allData));
    } on FirebaseException catch (e) {
      emit(VocabError(e.message.toString()));
    } catch (e) {
      emit(VocabError(e.toString()));
    }
  }
}
