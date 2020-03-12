import 'package:daily_manager/data/notesDataBase.dart';
import 'package:daily_manager/data/notesModel.dart';
import 'package:daily_manager/ui/widgets/noteListRow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<NotesModel> notesList = new List();
  NotesDataBaseService db = new NotesDataBaseService();

  @override
  void initState() {
    super.initState();
    db.init();
    setNotesFromDb();
  }

  void setNotesFromDb() async {
    var fetchedNotes = await NotesDataBaseService.db.getNotesFromDB();
    setState(() {
      notesList.clear();
      notesList = fetchedNotes;
      notesList.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  @override
  void didUpdateWidget(NotesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    notesList.clear();
    setNotesFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: _buildListView()),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
        itemCount: notesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(children: <Widget>[
            Slidable(
              key: ValueKey(index),
              child: NoteListRowWidget(notesList[index]),
              closeOnScroll: true,
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Theme.of(context).accentColor,
                  icon: Icons.delete,
                  onTap: () =>
                      NotesModel.deleteModel(notesList[index], deleteChanges),
                ),
              ],
            )
          ]);
        });
  }

  deleteChanges() {
    setState(() {
      showDeletedSnakeBar();
      setNotesFromDb();
    });
  }

  showDeletedSnakeBar() {
    final snackBar = SnackBar(
      content: Text('Note has been deleted'),
      backgroundColor: Theme.of(context).accentColor,
      duration: Duration(milliseconds: 1000),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
