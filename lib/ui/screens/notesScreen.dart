import 'package:daily_manager/data/notesDataBase.dart';
import 'package:daily_manager/data/notesModel.dart';
import 'package:daily_manager/ui/screens/newNote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<NotesModel> notesList = new List();
  bool isList = true;
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
      body: Container(child: _buildList()),
    );
  }

  Widget _buildList() {
    if (isList == true) {
      return _buildListView();
    } else if (isList == false) {
      return _buildGridView();
    }
    return null;
  }

  Widget _buildListView() {
    return ListView.builder(
        itemCount: notesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(children: <Widget>[
            Slidable(
              key: ValueKey(index),
              child: noteList(index),
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Theme.of(context).accentColor,
                  icon: Icons.delete,
                  onTap: () => deleteModel(index),
                ),
              ],
            )
          ]);
        });
  }

  Widget noteList(int index) {
    return ListTile(
      title: Text(
        '${notesList[index].content.length >= 30 ? notesList[index].content.replaceRange(30, notesList[index].content.length, '....') : notesList[index].content}',
        maxLines: 1,
        style: TextStyle(fontSize: 20.0),
      ),
      subtitle: Text(
        '${notesList[index].date}',
        style: TextStyle(fontSize: 12.0),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewNote(NotesModel(
                      id: notesList[index].id,
                      content: notesList[index].content,
                      isFav: notesList[index].isFav,
                      date: notesList[index].date,
                    ))));
      },
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      padding: EdgeInsets.all(5),
      crossAxisCount: 3,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: List.generate(notesList.length, (index) {
        return Container(
          child: ListTile(
            title: Text(
              '${notesList[index].content}',
              style: TextStyle(fontSize: 16.0),
            ),
            subtitle: Text(
              '${notesList[index].date}',
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        );
      }),
    );
  }

  deleteModel(int index) {
    db.deleteNoteInDB(NotesModel(id: notesList[index].id)).then((_) {
      setState(() {
        showDeletedSnakeBar();
        setNotesFromDb();
      });
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
