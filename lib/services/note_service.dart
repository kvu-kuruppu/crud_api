import 'dart:convert';

import 'package:crud_api/models/api_response.dart';
import 'package:crud_api/models/note.dart';
import 'package:crud_api/models/note_for_listing.dart';
import 'package:crud_api/models/note_insert.dart';
import 'package:http/http.dart' as http;

class NoteService {
  static const API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';
  static const headers = {
    'apiKey': '861587e7-4efc-4dee-9ab4-b000fa846867',
    'Content-Type': 'application/json'
  };

  Future<APIResponse<List<NoteForListing>>> getNotesList() {
    return http.get(Uri.parse('$API/notes'), headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);

        final notes = <NoteForListing>[];

        for (var item in jsonData) {
          notes.add(NoteForListing.fromJson(item));
        }

        return APIResponse<List<NoteForListing>>(data: notes);
      }

      return APIResponse<List<NoteForListing>>(
        error: true,
        errorMsg: 'An error occured',
      );
    }).catchError((_) => APIResponse<List<NoteForListing>>(
          error: true,
          errorMsg: 'An error occured',
        ));
  }

  Future<APIResponse<Note>> getNote(String noteID) {
    return http
        .get(Uri.parse('$API/notes/$noteID'), headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);

        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }

      return APIResponse<Note>(
        error: true,
        errorMsg: 'An error occured',
      );
    }).catchError((_) => APIResponse<Note>(
              error: true,
              errorMsg: 'An error occured',
            ));
  }

  Future<APIResponse<bool>> createNote(NoteManipulation item) {
    return http
        .post(
      Uri.parse('$API/notes'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    )
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }

      return APIResponse<bool>(
        error: true,
        errorMsg: 'An error occured',
      );
    }).catchError((_) => APIResponse<bool>(
              error: true,
              errorMsg: 'An error occured',
            ));
  }

  Future<APIResponse<bool>> updateNote(String noteID, NoteManipulation item) {
    return http
        .put(
      Uri.parse('$API/notes/$noteID'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    )
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }

      return APIResponse<bool>(
        error: true,
        errorMsg: 'An error occured',
      );
    }).catchError((_) => APIResponse<bool>(
              error: true,
              errorMsg: 'An error occured',
            ));
  }

  Future<APIResponse<bool>> deleteNote(String noteID) {
    return http
        .delete(
      Uri.parse('$API/notes/$noteID'),
      headers: headers,
    )
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }

      return APIResponse<bool>(
        error: true,
        errorMsg: 'An error occured',
      );
    }).catchError((_) => APIResponse<bool>(
              error: true,
              errorMsg: 'An error occured',
            ));
  }
}
