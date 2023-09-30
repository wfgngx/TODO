class TaskModel {
  String id;
  String title;
  String description;
  int date;
  bool isDone;

  TaskModel(
      {this.id = "",
      required this.title,
      required this.date,
      required this.description,
      this.isDone = false});
  TaskModel.fromJson(Map<String, dynamic> json)
      : this(
            title: json['title'],
            description: json['description'],
            date: json['date'],
            id: json['id'],
            isDone: json['isDone']);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "isDone": isDone,
    };
  }
}
// class TaskModel {
//   String id;
//   String title;
//   String description;
//   int date;
//   bool isDone;
//
//   TaskModel({
//     this.id,
//     required this.title,
//     required this.date,
//     required this.description,
//     this.isDone = false,
//   });
//
//   TaskModel.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         title = json['title'],
//         description = json['description'],
//         date = json['date'],
//         isDone = json['isDone'];
//
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "title": title,
//       "description": description,
//       "date": date,
//       "isDone": isDone,
//     };
//   }
// }
