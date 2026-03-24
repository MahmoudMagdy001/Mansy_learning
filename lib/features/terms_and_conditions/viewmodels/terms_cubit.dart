import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/terms_model.dart';
import '../repositories/terms_repository.dart';

abstract class TermsState extends Equatable {
  const TermsState();

  @override
  List<Object?> get props => [];
}

class TermsInitial extends TermsState {}

class TermsLoading extends TermsState {}

class TermsSuccess extends TermsState {
  final TermsAndConditionsModel terms;

  const TermsSuccess(this.terms);

  @override
  List<Object?> get props => [terms];
}

class TermsError extends TermsState {
  final String message;

  const TermsError(this.message);

  @override
  List<Object?> get props => [message];
}

class TermsCubit extends Cubit<TermsState> {
  final TermsRepository repository;

  TermsCubit(this.repository) : super(TermsInitial());

  void getTerms() {
    emit(TermsLoading());
    try {
      final terms = repository.getTerms();
      emit(TermsSuccess(terms));
    } catch (e) {
      emit(TermsError(e.toString()));
    }
  }
}
