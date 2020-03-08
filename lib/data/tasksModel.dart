class TasksModel {
  int id;
  String content;
  bool isDone;
  DateTime date;

  TasksModel.empty();

  TasksModel({this.id,this.content, this.isDone, this.date});

  TasksModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.content = map['content'];
    this.date = DateTime.parse(map['date']);
    this.isDone = map['isDone'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() {
    return <String,dynamic>{
      'id' : this.id,
      'content': this.content,
      'isDone': this.isDone == true ? 1 : 0,
      'date': this.date.toIso8601String()
    };
  }
}
