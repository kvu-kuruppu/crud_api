import 'package:crud_api/models/api_response.dart';
import 'package:crud_api/models/note_for_listing.dart';
import 'package:crud_api/services/note_service.dart';
import 'package:crud_api/views/note_delete.dart';
import 'package:crud_api/views/note_modify.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoteService get service => GetIt.I<NoteService>();
  APIResponse<List<NoteForListing>>? _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Notes')),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_apiResponse!.error) {
            return Center(child: Text(_apiResponse!.errorMsg!));
          }

          return ListView.separated(
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Colors.green),
            itemCount: _apiResponse!.data!.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey(_apiResponse!.data![index].noteID),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {},
                confirmDismiss: (direction) async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) => const NoteDelete(),
                  );

                  if (result) {
                    final deleteResult = await service
                        .deleteNote(_apiResponse!.data![index].noteID!);

                    var msg;

                    if (deleteResult.data == true) {
                      msg = 'Note was deleted successfully';
                    } else {
                      msg = deleteResult.errorMsg ?? 'An error occured';
                    }

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Done'),
                        content: Text(msg),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );

                    return deleteResult.data ?? false;
                  }

                  return result;
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(15.0),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: ListTile(
                  title: Text(_apiResponse!.data![index].noteTitle!),
                  subtitle: Text(
                    'Last edited on ${DateFormat.yMd().format(_apiResponse!.data![index].lastEdited ?? _apiResponse!.data![index].created!)}',
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (context) =>
                          NoteModify(noteID: _apiResponse!.data![index].noteID),
                    ))
                        .then((_) {
                      _fetchNotes();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => const NoteModify(),
          ))
              .then((_) {
            _fetchNotes();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
