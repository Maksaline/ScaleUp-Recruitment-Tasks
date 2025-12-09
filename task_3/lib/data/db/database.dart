import 'package:drift/drift.dart';

part 'database.g.dart';

class NoteItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  IntColumn get colorId => integer()();
  DateTimeColumn get updated => dateTime().nullable()();
}

@DriftDatabase(tables: [NoteItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => throw UnimplementedError();
}