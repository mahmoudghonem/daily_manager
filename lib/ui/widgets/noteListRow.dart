import 'package:daily_manager/data/notesModel.dart';
import 'package:daily_manager/ui/screens/newNote.dart';
import 'package:flutter/material.dart';

class NoteListRowWidget extends StatelessWidget {

  NotesModel note = new NotesModel();
  NoteListRowWidget(this.note);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      title: Text(
        '${note.content.length >= 30 ? note.content.replaceRange(30, note.content.length, '....') : note.content}',
        maxLines: 1,
        style: TextStyle(fontSize: 20.0),
      ),
      subtitle: Text(
        '${note.date}',
        style: TextStyle(fontSize: 12.0),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewNote(NotesModel(
                      id: note.id,
                      content: note.content,
                      isFav: note.isFav,
                      date: note.date,
                    ))));
      },
    );
  }
}
