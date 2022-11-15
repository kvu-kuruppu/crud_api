class Note {
  String? noteID;
  String? noteTitle;
  String? noteContent;
  DateTime? created;
  DateTime? lastEdited;

  Note({
    this.noteID,
    this.noteTitle,
    this.noteContent,
    this.created,
    this.lastEdited,
  });

  factory Note.fromJson(Map<String, dynamic> jsonData) {
    return Note(
      noteID: jsonData['noteID'],
      noteTitle: jsonData['noteTitle'],
      noteContent: jsonData['noteContent'],
      created: DateTime.parse(jsonData['createDateTime']),
      lastEdited: jsonData['latestEditDateTime'] != null
          ? DateTime.parse(jsonData['latestEditDateTime'])
          : null,
    );
  }
}
