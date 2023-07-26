part of 'vocab_bloc.dart';

abstract class VocabState {}

class VocabInitial extends VocabState {}

class VocabLoading extends VocabState {}

class VocabCompleteAdd extends VocabState {}

class VocabCompleteUpdate extends VocabState {}

class VocabCompleteDelete extends VocabState {}

class VocabError extends VocabState {
  String message;
  VocabError(this.message);
}
