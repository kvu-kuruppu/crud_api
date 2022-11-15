import 'package:crud_api/services/note_service.dart';
import 'package:crud_api/views/note_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => NoteService());
  // GetIt.instance.registerLazySingleton(() => NoteService());
}

void main() {
  setupLocator();
  runApp(
    const MaterialApp(
      home: NoteList(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
