import 'package:equatable/equatable.dart';

enum Status {
  pending,
  synced,
  failed,
}

class Note extends Equatable{
  final int id;
  final String title;
  final String content;
  final int colorId;
  final DateTime? updated;
  final Status status;

  const Note ({
    required this.id,
    required this.title,
    required this.content,
    required this.colorId,
    this.updated,
    this.status = Status.pending,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    colorId,
    updated,
    status,
  ];

}