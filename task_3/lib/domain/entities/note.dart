import 'package:equatable/equatable.dart';

enum Status {
  pending,
  synced,
  failed,
}

class Note extends Equatable{
  final int id;
  String title;
  String content;
  int colorId;
  DateTime? updated;
  Status status;

  Note ({
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