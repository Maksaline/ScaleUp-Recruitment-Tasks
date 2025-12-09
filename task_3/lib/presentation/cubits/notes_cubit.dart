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

  void addNote(String title, String content, int colorId, bool isOnline) async {
    int syncStatus = 0;
    if(isOnline) {
      final response = await dio.post('https://jsonplaceholder.typicode.com/posts',
          data: {
            'title': title,
            'body': content,
            'userId': 11,
          });
      if(response.statusCode == 201) {
        syncStatus = 1;
      }
    }
    
    await db.into(db.noteItems).insert(NoteItemsCompanion(
      title: Value(title),
      content: Value(content),
      colorId: Value(colorId),
      status: Value(syncStatus),
      updated: Value(DateTime.now()),
    ));
    fetchNotes();
  }
  
  void deleteNote(int id) async {
    await db.managers.noteItems.filter((f) => f.id.equals(id)).delete();
    
    fetchNotes();
  }

  void updateNote(int id, String title, String content, int colorId, int status, bool isOnline) async {
    int syncStatus = status;
    if(isOnline) {
      final response = await dio.put('https://jsonplaceholder.typicode.com/posts/$id',
          data: {
            'title': title,
            'body': content,
            'userId': 11,
          });
      if(response.statusCode == 200) {
        syncStatus = 1;
      } else if (syncStatus != 0){
        syncStatus = 2;
      } else {
        syncStatus = 0;
      }
    }

    await db.managers.noteItems
        .filter((f) => f.id.equals(id))
        .update((u) => u(title: Value(title), content: Value(content), colorId: Value(colorId), status: Value(syncStatus), updated: Value(DateTime.now())));
    fetchNotes();
  }

  void updateOnNetwork() async {
    List<NoteItem> notes = await db.managers.noteItems.filter((f) => f.status.equals(0)).get();

    for(NoteItem note in notes) {
      int syncStatus = 0;
      if(note.status == 0) {
        final response = await dio.post('https://jsonplaceholder.typicode.com/posts',
            data: {
              'title': note.title,
              'body': note.content,
              'userId': 11
            });
        if(response.statusCode == 201) {
          syncStatus = 1;
        }
      } else if (note.status == 2) {
        final response = await dio.put('https://jsonplaceholder.typicode.com/posts/${note.id}',
            data: {
              'title': note.title,
              'body': note.content,
              'userId': 11,
            });
        if(response.statusCode == 200) {
          syncStatus = 1;
        }
      }
      await db.managers.noteItems.filter((f) => f.id.equals(note.id)).update((u) => u(status: Value(syncStatus)));
    }
    fetchNotes();
  }
}