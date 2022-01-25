import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Model {
  String? id;

  Map<String, dynamic> toMap();
}

void _onError(Exception e) =>
    BotToast.showSimpleNotification(title: e.toString());


Future tryRun(Function action, [Function(Exception)? onError]) async {
  try {
    final result = await action();
    return result ?? true;
  } catch (e) {
    onError?.call(e as Exception);
    return null;
  }
}

class Controller<T extends Model> {
  final CollectionReference ref;

  Controller(String collectionName)
      : ref = FirebaseFirestore.instance.collection(collectionName);

  Future<DocumentReference?> insert(T model) async {
    final result = await tryRun(() => ref.add(model.toMap()), _onError);
    return result;
  }

  Future<DocumentSnapshot?> find(String id) async {
    final result = await tryRun(() => ref.doc(id).get(), _onError);
    return result;
  }

  Future<QuerySnapshot?> get(
      {DocumentSnapshot? afterDoc,
      dynamic after,
      int? limit,
      String? orderBy,
      bool desc = false}) async {
    late Query query = ref;
    if (limit != null) {
      query = query.limit(limit);
    }
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: desc);
    }
    if (afterDoc != null) {
      query = query.startAfterDocument(afterDoc);
    }
    if (after != null) {
      query = query.startAfter([after]);
    }

    final result = await tryRun(() => query.get(), _onError);
    return result;
  }

  Future<bool?> update(T model) async {
    final result =
        await tryRun(() => ref.doc(model.id).update(model.toMap()), _onError);
    return result;
  }

  Future<bool?> remove(T model) async {
    final result = await tryRun(() => ref.doc(model.id).delete(), _onError);
    return result;
  }

  Future<bool?> drop() async {
    var dropResult = true;
    final result = await tryRun(() => get(), _onError);
    if (result == null) return result;
    for (final doc in (result as QuerySnapshot).docs) {
      try {
        doc.reference.delete();
      } catch (_) {
        dropResult = false;
      }
    }
    return dropResult ? true : null;
  }

  Future query(Query query) async {
    final result = await tryRun(query.get, _onError);
    return result;
  }
}
