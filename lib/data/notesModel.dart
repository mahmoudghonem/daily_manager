import 'notesDataBase.dart';

class NotesModel {
  int id;
  String content;
  bool isFav;
  DateTime date;

  NotesModel.empty();

  NotesModel({this.id,this.content, this.isFav, this.date});

  NotesModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.content = map['content'];
    this.date = DateTime.parse(map['date']);
    this.isFav = map['isFav'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() {
    return <String,dynamic>{
      'id' : this.id,
      'content': this.content,
      'isFav': this.isFav == true ? 1 : 0,
      'date': this.date.toIso8601String()
    };
  }
  NotesDataBaseService db = new NotesDataBaseService();
  NotesModel.deleteModel(NotesModel model,Function deleteChanges) {
    db.deleteNoteInDB(NotesModel(id: model.id)).then((_) {
      deleteChanges();
    });
  }
}
