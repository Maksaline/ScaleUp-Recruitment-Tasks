import 'package:flutter/material.dart';
import 'package:task_3/core/colors/note_colors.dart';

class ColorList {
  List<NoteColor> list = [];

  ColorList() {
    list.add(NoteColor(id: 0, color: Colors.transparent));
    list.add(NoteColor(id: 1, color: Colors.red.shade300));
    list.add(NoteColor(id: 2, color: Colors.green.shade300));
    list.add(NoteColor(id: 3, color: Colors.orange.shade300));
    list.add(NoteColor(id: 4, color: Colors.purple.shade300));
    list.add(NoteColor(id: 5, color: Colors.teal.shade300));
  }

  Color getColor(int id, BuildContext context) {
    if(id == 0) {
      return Theme.of(context).colorScheme.onSecondary;
    }
    return list.firstWhere((element) => element.id == id).color;
  }

  List<NoteColor> getList() {
    return list;
  }
}