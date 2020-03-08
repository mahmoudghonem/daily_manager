import 'package:daily_manager/ui/screens/notesScreen.dart';
import 'package:daily_manager/ui/screens/tasksScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool isNote = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Daily Manager'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => openNotes(),
            child: Text('Notes'),
            textColor: isNote ? Colors.orange : Colors.white,
          ),
          FlatButton(
              onPressed: () => openTasks(),
              child: Text('Tasks'),
              textColor: isNote ? Colors.white : Colors.orange),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.0),
        child: GestureDetector(
          child: _buildChild(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddingNewScreen(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildChild() {
    if (isNote == true) {
      return NotesScreen();
    } else if (isNote == false) {
      return TasksScreen();
    }
    return null;
  }

  openNotes() {
    setState(() {
      isNote = true;
    });
  }

  openTasks() {
    setState(() {
      isNote = false;
    });
  }

  openAddingNewScreen() {
    if (isNote == true) {
      openNewNote();
    } else if (isNote == false) {
      openNewTask();
    }
  }

  openNewNote() {
    Navigator.pushNamed(context, '/newNoteScreen');
  }

  openNewTask() {
    Navigator.pushNamed(context, '/newTaskScreen');
  }
}
