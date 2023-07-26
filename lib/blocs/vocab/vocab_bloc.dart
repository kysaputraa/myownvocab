import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

part 'vocab_event.dart';
part 'vocab_state.dart';

class VocabBloc extends Bloc<VocabEvent, VocabState> {
  VocabBloc() : super(VocabInitial()) {
    on<VocabEventAdd>((event, emit) async {
      try {
        emit(VocabLoading());
        var result = await FirebaseFirestore.instance.collection("vocab").add({
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
    on<VocabEventUpdate>((event, emit) async {
      try {
        emit(VocabLoading());
        await FirebaseFirestore.instance
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

    on<VocabEventDelete>((event, emit) async {
      try {
        emit(VocabLoading());
        await FirebaseFirestore.instance
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
  }
}
