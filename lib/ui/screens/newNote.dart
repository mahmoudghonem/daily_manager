import 'package:daily_manager/data/notesDataBase.dart';
import 'package:daily_manager/data/notesModel.dart';
import 'package:flutter/material.dart';

class NewNote extends StatefulWidget {
  final NotesModel model;

  @override
  State<StatefulWidget> createState() => _NewNoteState();
  NewNote([this.model]);
}

class _NewNoteState extends State<NewNote> {
  final myController = TextEditingController();
  bool textInputChecker = false;
  NotesDataBaseService db = new NotesDataBaseService();
  bool oldNote = false;
  NotesModel model = new NotesModel();
  @override
  void initState() {
    super.initState();
    myController.addListener(textInputCheckerIsNotEmpty);
    model = widget.model;
    checkIfOldNote();
  }

  textInputCheckerIsNotEmpty() {
    if (myController.text.isNotEmpty) {
      setState(() {
        textInputChecker = true;
      });
    }
    if (myController.text.isEmpty) {
      setState(() {
        textInputChecker = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  checkIfOldNote() {
    if (model != null) {
      setState(() {
        oldNote = true;
        myController.text = model.content;
      });
    } else {
      oldNote = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          if (oldNote)
            IconButton(
                icon: Icon(Icons.delete), onPressed: () => deleteNote(context)),
          if (textInputChecker)
            IconButton(
                icon: Icon(Icons.save), onPressed: () => addOrUpdateNote()),
        ],
      ),
      body: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (oldNote) {
      return _buildOldNote();
    } else {
      return _buildNewNote();
    }
  }

  Widget _buildNewNote() {
    return Container(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Text("${DateTime.now()}"),
          Expanded(
            child: TextField(
              controller: myController,
              enableInteractiveSelection: true,
              expands: true,
              maxLines: null,
              minLines: null,
              style: TextStyle(
                fontSize: 24,
              ),
              decoration: InputDecoration(),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildOldNote() {
    return Container(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Text("${model.date}"),
          Expanded(
            child: TextField(
              controller: myController,
              enableInteractiveSelection: true,
              expands: true,
              maxLines: null,
              minLines: null,
              style: TextStyle(
                fontSize: 24,
              ),
              decoration: InputDecoration(),
            ),
          ),
        ],
      ),
    ));
  }

  addOrUpdateNote() {
    if (oldNote) {
      model.content = myController.text;
      model.date = DateTime.now();

      db.updateNoteInDB(model).then((_) {
        Navigator.pop(context);
      });
    } else {
      db
          .addNoteInDB(NotesModel(
              content: myController.text, isFav: false, date: DateTime.now()))
          .then((_) {
        Navigator.pop(context);
      });
    }
  }

  deleteNote(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Are you sure?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context), child: Text('No')),
              FlatButton(
                  onPressed: () => {
                        db.deleteNoteInDB(model).then((_) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        })
                      },
                  child: Text('Yes'))
            ],
          );
        });
  }
}
