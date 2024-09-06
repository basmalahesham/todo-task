class TaskModel {
  static const String collectionName = "Tasks";
  String? id;
  String? title;
  String? description;
  bool? isDone;
  int? dateTime;

  TaskModel(
      {this.id, this.title, this.description, this.isDone, this.dateTime});

  TaskModel.fromFireStore(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          isDone: json['isDone'],
          dateTime: json['dateTime'],
        );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'dateTime': dateTime,
    };
  }
}
