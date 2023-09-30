import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_route/Models/task_model.dart';

class FirebaseFunctions {
  static CollectionReference<TaskModel> getTaskCollection() {
    return FirebaseFirestore.instance
        .collection('Tasks')
        .withConverter<TaskModel>(
      fromFirestore: (snapshot, _) {
        final data = snapshot.data()!;
        return TaskModel.fromJson(data)..id = snapshot.id;
      },
      toFirestore: (value, _) {
        return value.toJson();
      },
    );
  }

  static Future<void> addTask(TaskModel task) {
    var collection = getTaskCollection();
    var doc = collection.doc();
    task.id = doc.id;
    return doc.set(task);
  }

  static Stream<QuerySnapshot<TaskModel>> getTasks(DateTime date) {
    return getTaskCollection()
        .where("date",
            isEqualTo: DateUtils.dateOnly(date).millisecondsSinceEpoch)
        .snapshots();
  }

  static Future<void> deleteTask(String id) {
    return getTaskCollection().doc(id).delete();
  }

  static Future<void> updateTask(String id, TaskModel task) async {
    return getTaskCollection().doc(id).set(task);
  }
}
// class FirebaseFunctions {
//   static CollectionReference<TaskModel> getTaskCollection() {
//     return FirebaseFirestore.instance
//         .collection('Tasks')
//         .withConverter<TaskModel>(
//       fromFirestore: (snapshot, _) {
//         return TaskModel.fromJson(snapshot.data()!);
//       },
//       toFirestore: (value, _) {
//         return value.toJson();
//       },
//     );
//   }
//
//   static Future<void> addTask(TaskModel task) {
//     var collection = getTaskCollection();
//     var doc = collection.doc();
//     task.id = doc.id;
//     return doc.set(task);
//   }
//
//   static Stream<QuerySnapshot<TaskModel>> getTasks(DateTime date) {
//     return getTaskCollection()
//         .where("date",
//             isEqualTo: DateUtils.dateOnly(date).millisecondsSinceEpoch)
//         .snapshots();
//   }
//
//   static Future<void> deleteTask(String id) {
//     return getTaskCollection().doc(id).delete();
//   }
//
//   static Future<void> updateTask(String id, TaskModel task)async {
//     return await getTaskCollection().doc(id).update(task.toJson());
//   }
// }
