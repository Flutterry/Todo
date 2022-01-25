import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller_manager.dart';

class Task extends Model {
  Timestamp? date;
  String? title;
  bool? isCompleted;

  static const collectionName = 'Applications/todo/Tasks';
  static CollectionReference get ref =>
      FirebaseFirestore.instance.collection(collectionName);

  Task({
    this.date,
    this.title,
    this.isCompleted,
  });

  factory Task.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map? ?? {};
    final model = Task();
    model.id = snapshot.id;
    model.date = data["date"];
    model.title = data["title"];
    model.isCompleted = data["isCompleted"];

    return model;
  }

  @override
  Map<String, dynamic> toMap() => {
        if (date != null) 'date': date,
        if (title != null) 'title': title,
        if (isCompleted != null) 'isCompleted': isCompleted,
      };

  String toJson() => json.encode(toMap());

  Task copyWith({
    Timestamp? date,
    String? title,
    bool? isCompleted,
  }) {
    this.date = date ?? this.date;
    this.title = title ?? this.title;
    this.isCompleted = isCompleted ?? this.isCompleted;

    return this;
  }
}
