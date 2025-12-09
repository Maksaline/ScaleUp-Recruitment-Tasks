import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../data/db/database.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  final db = AppDatabase();
  final dio = Dio();

  void fetchNotes() async {
    emit(NotesLoading());

    List<NoteItem> notes = await db.managers.noteItems.orderBy((o) => o.updated.desc()).get();
    if (notes.isEmpty) {
      emit(NotesEmpty());
    } else {
      emit(NotesLoaded(notes: notes));
    }
  }

  void addNote(String title, String content, int colorId) async {
    await db.into(db.noteItems).insert(NoteItemsCompanion(
      title: Value(title),
      content: Value(content),
      colorId: Value(colorId),
      status: Value(0),
      updated: Value(DateTime.now()),
    ));
    fetchNotes();
  }
  
  void deleteNote(int id) async {
    await db.managers.noteItems.filter((f) => f.id.equals(id)).delete();
    fetchNotes();
  }

  void updateNote(int id, String title, String content, int colorId) async {
    await db.managers.noteItems
        .filter((f) => f.id.equals(id))
        .update((u) => u(title: Value(title), content: Value(content), colorId: Value(colorId), updated: Value(DateTime.now())));
    fetchNotes();
  }
}