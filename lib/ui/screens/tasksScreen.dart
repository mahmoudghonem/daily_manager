import 'package:daily_manager/data/tasksDataBase.dart';
import 'package:daily_manager/data/tasksModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'newTask.dart';

class TasksScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TasksModel> tasksList = new List();
  TasksDataBaseService db = new TasksDataBaseService();
  TasksModel model;
  bool checkValue;
  @override
  void initState() {
    super.initState();
    db.init();
    setTasksFromDb();
  }

  void setTasksFromDb() async {
    var fetchedTasks = await TasksDataBaseService.db.getTasksFromDB();
    setState(() {
      tasksList.clear();
      tasksList = fetchedTasks;
      tasksList
          .sort((a, b) => a.isDone.toString().compareTo(b.isDone.toString()));
    });
  }

  @override
  void didUpdateWidget(TasksScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    tasksList.clear();
    setTasksFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: _buildList()),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: tasksList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(children: <Widget>[
            Slidable(
              key: ValueKey(index),
              child: taskList(index),
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

  Widget taskList(int index) {
    return ListTile(
      leading: Checkbox(
        activeColor: Theme.of(context).accentColor,
        value: tasksList[index].isDone,
        onChanged: (val) {
          setState(() {
            checkValue = val;
            changeTaskDone(index, checkValue);
          });
        },
      ),
      title: Text(
        '${tasksList[index].content.length >= 30 ? tasksList[index].content.replaceRange(30, tasksList[index].content.length, '....') : tasksList[index].content}',
        maxLines: 1,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewTask(TasksModel(
                      id: tasksList[index].id,
                      content: tasksList[index].content,
                      isDone: tasksList[index].isDone,
                      date: tasksList[index].date,
                    ))));
      },
    );
  }

  changeTaskDone(int index, bool value) {
    model = TasksModel(
      id: tasksList[index].id,
      content: tasksList[index].content,
      isDone: value,
      date: tasksList[index].date,
    );
    db.updateTaskInDB(model).then((_) {
      setState(() {
        setTasksFromDb();
      });
    });
  }

  deleteModel(int index) {
    db.deleteTaskInDB(TasksModel(id: tasksList[index].id)).then((_) {
      setState(() {
        showDeletedSnakeBar();
        setTasksFromDb();
      });
    });
  }

  showDeletedSnakeBar() {
    final snackBar = SnackBar(
      content: Text('Task has been deleted'),
      backgroundColor: Theme.of(context).accentColor,
      duration: Duration(milliseconds: 1000),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
