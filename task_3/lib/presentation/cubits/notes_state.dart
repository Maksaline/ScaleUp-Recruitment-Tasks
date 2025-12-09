part of 'notes_cubit.dart';


@immutable
sealed class NotesState {}

class NotesInitial extends NotesState {}

class NotesEmpty extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<NoteItem> notes;

  NotesLoaded({required this.notes});
}

class NotesError extends NotesState {
  final String message;

  NotesError({required this.message});
}


