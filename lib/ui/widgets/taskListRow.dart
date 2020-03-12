import 'package:daily_manager/data/tasksModel.dart';
import 'package:daily_manager/ui/screens/newTask.dart';
import 'package:flutter/material.dart';

class TaskListRowWidget extends StatefulWidget {
  TasksModel task = new TasksModel();
  Function viewChanges;

  TaskListRowWidget(this.task,this.viewChanges);

  @override
  State<StatefulWidget> createState() => _TaskListRowWidgetState();
}

class _TaskListRowWidgetState extends State<TaskListRowWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      leading: Checkbox(
        activeColor: Theme.of(context).accentColor,
        value: widget.task.isDone,
        onChanged: (val) {
          bool checkValue = val;
          TasksModel.changeTaskDone(widget.task, checkValue,widget.viewChanges);
        },
      ),
      title: Text(
        '${widget.task.content.length >= 30 ? widget.task.content.replaceRange(30, widget.task.content.length, '....') : widget.task.content}',
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
                      id: widget.task.id,
                      content: widget.task.content,
                      isDone: widget.task.isDone,
                      date: widget.task.date,
                    ))));
      },
    );
  }
}
