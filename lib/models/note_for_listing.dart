class NoteForListing {
  String? noteID;
  String? noteTitle;
  DateTime? created;
  DateTime? lastEdited;

  NoteForListing({
    this.noteID,
    this.noteTitle,
    this.created,
    this.lastEdited,
  });

  factory NoteForListing.fromJson(Map<String, dynamic> item) {
    return NoteForListing(
      noteID: item['noteID'],
      noteTitle: item['noteTitle'],
      created: DateTime.parse(item['createDateTime']),
      lastEdited: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}
