import 'package:daily_manager/data/tasksDataBase.dart';
import 'package:daily_manager/data/tasksModel.dart';
import 'package:daily_manager/ui/widgets/taskListRow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
              child: TaskListRowWidget(tasksList[index], viewChanges),
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Theme
                      .of(context)
                      .accentColor,
                  icon: Icons.delete,
                  onTap: () =>
                      TasksModel.deleteModel(tasksList[index], deleteChanges),
                ),
              ],
            )
          ]);
        });
  }

  viewChanges() {
    setState(() {
      setTasksFromDb();
    });
  }

  deleteChanges() {
    setState(() {
      showDeletedSnakeBar();
      setTasksFromDb();
    });
  }

  showDeletedSnakeBar() {
    final snackBar = SnackBar(
      content: Text('Task has been deleted'),
      backgroundColor: Theme
          .of(context)
          .accentColor,
      duration: Duration(milliseconds: 1000),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
