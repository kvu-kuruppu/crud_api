import 'package:crud_api/models/note.dart';
import 'package:crud_api/models/note_insert.dart';
import 'package:crud_api/services/note_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NoteModify extends StatefulWidget {
  final String? noteID;
  const NoteModify({Key? key, this.noteID}) : super(key: key);

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;
  NoteService get service => GetIt.I<NoteService>();
  String? errorMsg;
  Note? note;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });

      service.getNote(widget.noteID!).then((response) {
        setState(() {
          _isLoading = false;
        });
        if (response.error) {
          errorMsg = response.errorMsg ?? 'An error occured';
        }

        note = response.data;

        _titleController.text = note!.noteTitle!;

        _contentController.text = note!.noteContent!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Update note' : 'Create note',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Note Title'),
                    textInputAction: TextInputAction.next,
                  ),
                  TextField(
                    controller: _contentController,
                    decoration:
                        const InputDecoration(labelText: 'Note Content'),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isEditing) {
                          setState(() {
                            _isLoading = true;
                          });

                          final note = NoteManipulation(
                            noteTitle: _titleController.text,
                            noteContent: _contentController.text,
                          );

                          final result = await service.updateNote(
                            widget.noteID!,
                            note,
                          );

                          setState(() {
                            _isLoading = false;
                          });

                          const title = 'Done';
                          final text = result.error
                              ? (result.errorMsg ?? 'And error occured')
                              : 'Your note was updated';

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(title),
                              content: Text(text),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            )
                          ).then((data) {
                            if (result.data!) {
                              Navigator.of(context).pop();
                            }
                          });
                        } else {
                          setState(() {
                            _isLoading = true;
                          });

                          final note = NoteManipulation(
                            noteTitle: _titleController.text,
                            noteContent: _contentController.text,
                          );

                          final result = await service.createNote(note);

                          setState(() {
                            _isLoading = false;
                          });

                          const title = 'Done';
                          final text = result.error
                              ? (result.errorMsg ?? 'And error occured')
                              : 'Your note was created';

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(title),
                              content: Text(text),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ).then((data) {
                            if (result.data!) {
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
