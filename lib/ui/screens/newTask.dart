import 'package:daily_manager/data/tasksDataBase.dart';
import 'package:daily_manager/data/tasksModel.dart';
import 'package:flutter/material.dart';

class NewTask extends StatefulWidget {
 final TasksModel model;

  @override
  State<StatefulWidget> createState() => _NewTaskState();
  NewTask([this.model]);
}

class _NewTaskState extends State<NewTask> {
  final myController = TextEditingController();
  bool textInputChecker = false;
  TasksDataBaseService db = new TasksDataBaseService();
  bool oldTask = false;
  TasksModel model = new TasksModel();
  @override
  void initState() {
    super.initState();
    myController.addListener(textInputCheckerIsNotEmpty);
    model = widget.model;
    checkIfOldTask();
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

  checkIfOldTask() {
    if (model != null) {
      setState(() {
        oldTask = true;
        myController.text = model.content;
      });
    } else {
      oldTask = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          if (oldTask)
            IconButton(
                icon: Icon(Icons.delete), onPressed: () => deleteTask(context)),
          if (textInputChecker)
            IconButton(
                icon: Icon(Icons.save), onPressed: () => addOrUpdateTask()),
        ],
      ),
      body: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (oldTask) {
      return _buildOldTask();
    } else {
      return _buildNewTask();
    }
  }

  Widget _buildNewTask() {
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

  Widget _buildOldTask() {
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

  addOrUpdateTask() {
    if (oldTask) {
      model.content = myController.text;
      model.date = DateTime.now();

      db.updateTaskInDB(model).then((_) {
        Navigator.pop(context);
      });
    } else {
      db
          .addTaskInDB(TasksModel(
              content: myController.text, isDone: false, date: DateTime.now()))
          .then((_) {
        Navigator.pop(context);
      });
    }
  }

  deleteTask(BuildContext context) {
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
                        db.deleteTaskInDB(model).then((_) {
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
