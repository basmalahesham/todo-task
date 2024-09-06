import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_task/model/task_model.dart';


class FirestoreUtils {
  static CollectionReference<TaskModel> getCollection() {
    return FirebaseFirestore.instance
        .collection(TaskModel.collectionName)
        .withConverter<TaskModel>(
      fromFirestore: (snapshot, _) =>
          TaskModel.fromFireStore(snapshot.data()!),
      toFirestore: (taskModel, _) => taskModel.toFireStore(),
    );
  }

  static Future<void> addTask(TaskModel taskModel) async {
    var collection = getCollection();
    var doc = collection.doc();
    taskModel.id = doc.id;
    return doc.set(taskModel);
  }

  static Future<List<TaskModel>> getDataFromFirestore() async {
    var snapshots = await getCollection().get();
    List<TaskModel> tasksList =
    snapshots.docs.map((element) => element.data()).toList();
    return tasksList;
  }

  static Stream<QuerySnapshot<TaskModel>> getRealTimeDataFromFirestore(
      DateTime dateTime) {
    return getCollection()
        .where("dateTime",
        isEqualTo:
        MyDateTime.externalDateOnly(dateTime).millisecondsSinceEpoch)
        .snapshots();
  }

  static Future<void> deleteData(TaskModel model) {
    var collectionRef = getCollection().doc(model.id);
    return collectionRef.delete();
  }

  static Future<void> isDoneTask(TaskModel model) async {
    getCollection().doc(model.id).update({'isDone': !model.isDone!});
  }

  static Future<void> updateTask(TaskModel model) async {
    getCollection().doc(model.id).update(model.toFireStore());
  }
}
class MyDateTime {
  static DateTime externalDateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}