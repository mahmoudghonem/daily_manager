import 'package:daily_manager/data/tasksDataBase.dart';
import 'package:daily_manager/ui/screens/tasksScreen.dart';

class TasksModel {
  int id;
  String content;
  bool isDone;
  DateTime date;

  TasksModel.empty();

  TasksModel({this.id, this.content, this.isDone, this.date});

  TasksModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.content = map['content'];
    this.date = DateTime.parse(map['date']);
    this.isDone = map['isDone'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'content': this.content,
      'isDone': this.isDone == true ? 1 : 0,
      'date': this.date.toIso8601String()
    };
  }
  TasksDataBaseService db = new TasksDataBaseService();

  TasksModel.changeTaskDone(TasksModel model, bool value, Function viewChanges) {

    model = TasksModel(
      id: model.id,
      content: model.content,
      isDone: value,
      date: model.date,
    );
    db.updateTaskInDB(model).then((_) {
      viewChanges();
    });
  }
  TasksModel.deleteModel(TasksModel model,Function deleteChanges) {
    db.deleteTaskInDB(TasksModel(id: model.id)).then((_) {
      deleteChanges();
    });
  }
}
